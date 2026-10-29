// Draws the "on this page" line: one SVG path down the left of the list that
// jogs right for sub-headings and back for top-level ones. The stretch above
// the section being read is filled in, and a dot glides along the path to it.
// After https://x.com/raul_dronca/status/2005951699886747981.
// Narrow screens get a reading-progress bar instead; see toc.html.
(() => {
    const toc = document.querySelector(".toc");
    if (!toc) return;

    const fold = toc.querySelector(".toc-fold");
    const body = toc.querySelector(".toc-body");
    const svg = toc.querySelector(".toc-track");
    const line = svg.querySelector(".toc-line");
    const progress = svg.querySelector(".toc-progress");
    const end = svg.querySelector(".toc-end");
    const dot = svg.querySelector(".toc-dot");
    const bar = document.querySelector(".read-progress");
    const post = document.querySelector(".post-body");

    const X0 = 4; // where depth 0 sits, leaving room for the dot
    const INDENT = parseFloat(getComputedStyle(toc).getPropertyValue("--toc-indent")) || 16;
    const JOG = 7; // half-height of the S-curve between depths
    const READING_LINE = 0.25; // a heading is "current" once above this fraction of the viewport
    const reduceMotion = matchMedia("(prefers-reduced-motion: reduce)");
    const wide = matchMedia("(min-width: 1100px)");

    const depthOf = (a) => {
        let depth = 0;
        for (let n = a.parentElement; n && n !== body; n = n.parentElement) {
            if (n.tagName === "UL") depth++;
        }
        return depth;
    };

    const items = [...toc.querySelectorAll("nav a")]
        .map((a) => ({
            a,
            depth: depthOf(a),
            heading: document.getElementById(decodeURIComponent(a.hash.slice(1))),
        }))
        .filter((item) => item.heading);
    if (items.length < 2) return;
    const minDepth = Math.min(...items.map((item) => item.depth));

    let stops = []; // path length at each item
    let total = 0;
    let shown = 0; // length the dot is drawn at now
    let target = 0; // length it is heading for
    let active = -1;
    let frame = 0;

    // Straight down at one depth; an S-curve between depths.
    function pathThrough(points) {
        let d = `M ${points[0].x} ${points[0].y}`;
        for (let i = 1; i < points.length; i++) {
            const a = points[i - 1];
            const b = points[i];
            if (a.x === b.x) {
                d += ` L ${b.x} ${b.y}`;
                continue;
            }
            const mid = (a.y + b.y) / 2;
            const jog = Math.min(JOG, (b.y - a.y) / 2);
            d += ` L ${a.x} ${mid - jog} C ${a.x} ${mid}, ${b.x} ${mid}, ${b.x} ${mid + jog} L ${b.x} ${b.y}`;
        }
        return d;
    }

    function build() {
        if (!wide.matches) {
            toc.classList.remove("toc-live");
            stops = [];
            update(true);
            return;
        }
        const box = body.getBoundingClientRect();
        if (!box.height) return; // folded shut
        const points = items.map(({ a, depth }) => {
            // First line box, so a wrapped heading's dot sits by its first line.
            const r = a.getClientRects()[0] ?? a.getBoundingClientRect();
            return { x: X0 + (depth - minDepth) * INDENT, y: r.top - box.top + r.height / 2 };
        });
        svg.setAttribute("width", X0 * 2 + (Math.max(...items.map((i) => i.depth)) - minDepth) * INDENT);
        svg.setAttribute("height", box.height);
        line.setAttribute("d", pathThrough(points));
        progress.setAttribute("d", line.getAttribute("d"));
        const last = points[points.length - 1];
        end.setAttribute("cx", last.x);
        end.setAttribute("cy", last.y);

        // Length at each item: measure the path up to it.
        const probe = document.createElementNS("http://www.w3.org/2000/svg", "path");
        svg.appendChild(probe);
        stops = points.map((_, i) => {
            if (i === 0) return 0;
            probe.setAttribute("d", pathThrough(points.slice(0, i + 1)));
            return probe.getTotalLength();
        });
        probe.remove();
        total = stops[stops.length - 1];
        toc.classList.add("toc-live");
        update(true);
    }

    function currentIndex() {
        const atBottom = innerHeight + scrollY >= document.documentElement.scrollHeight - 2;
        if (atBottom) return items.length - 1;
        const reading = innerHeight * READING_LINE;
        let index = 0;
        items.forEach((item, i) => {
            if (item.heading.getBoundingClientRect().top <= reading) index = i;
        });
        return index;
    }

    function draw() {
        const p = line.getPointAtLength(shown);
        dot.setAttribute("cx", p.x);
        dot.setAttribute("cy", p.y);
        progress.style.strokeDasharray = `${shown} ${total + 1}`;
    }

    // Ease toward the target each frame, so the dot follows the curves.
    function animate() {
        const gap = target - shown;
        shown = Math.abs(gap) < 0.5 ? target : shown + gap * 0.18;
        draw();
        frame = shown === target ? 0 : requestAnimationFrame(animate);
    }

    // Fraction of the post read: 0 with its top at the top of the screen, 1 with
    // its bottom at the bottom.
    function updateBar() {
        if (wide.matches || !bar || !post) return;
        const r = post.getBoundingClientRect();
        const span = r.height - innerHeight;
        const read = span > 0 ? Math.min(1, Math.max(0, -r.top / span)) : 1;
        bar.style.transform = `scaleX(${read})`;
    }

    function update(instant = false) {
        updateBar();
        const index = currentIndex();
        if (index !== active) {
            items[active]?.a.classList.remove("toc-active");
            items[index].a.classList.add("toc-active");
            active = index;
        }
        if (!stops.length) return;
        target = stops[index];
        if (instant || reduceMotion.matches) {
            shown = target;
            draw();
        } else if (!frame) {
            frame = requestAnimationFrame(animate);
        }
    }

    // If the page grows mid-jump (an image without a size loading above the
    // target), the scroll lands short; re-aim until the reader takes over.
    let jumpTarget = null;
    let jumpUntil = 0;
    const endJump = () => (jumpTarget = null);
    new ResizeObserver(() =>
        requestAnimationFrame(() => {
            if (jumpTarget && performance.now() < jumpUntil) jumpTarget.scrollIntoView();
        }),
    ).observe(document.body);
    ["wheel", "touchstart", "keydown"].forEach((type) =>
        addEventListener(type, endJump, { passive: true }),
    );

    toc.addEventListener("click", (event) => {
        const a = event.target.closest("nav a");
        const item = a && items.find((i) => i.a === a);
        if (!item) return;
        event.preventDefault();
        jumpTarget = item.heading;
        jumpUntil = performance.now() + 3000;
        item.heading.scrollIntoView({ behavior: reduceMotion.matches ? "auto" : "smooth" });
        history.replaceState(null, "", a.hash);
    });

    // Open beside the post on wide screens, folded above it on narrow ones.
    // Rotating an iPad crosses the line, so switch modes live.
    const syncFold = () => (fold.open = wide.matches);
    wide.addEventListener("change", () => {
        syncFold();
        build();
    });
    syncFold();

    addEventListener("scroll", () => update(), { passive: true });
    // Next frame, not in the callback: bolding the active entry can rewrap the
    // list, which would resize it again inside the same observation.
    new ResizeObserver(() => requestAnimationFrame(build)).observe(body);
    fold.addEventListener("toggle", build);
    build();
})();
