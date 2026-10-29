// When the tab goes to the background, make it look like something I'd rather
// you didn't see. Idea from https://xn--gckvb8fzb.com/.
(() => {
    const titles = [
        "(3) mom: call me back",
        "how to tell if your homelab is a cry for help",
        "is it normal to have 130 omnifocus tags",
        "motorcycle insurance but cheaper - reddit",
        "can cats tell when you're bad at css",
        "why is my website purple - Google Search",
    ];
    const icons = [...document.querySelectorAll('link[rel~="icon"]')];
    const original = { title: document.title, hrefs: icons.map((l) => l.href) };

    document.addEventListener("visibilitychange", () => {
        if (document.hidden) {
            original.title = document.title;
            document.title = titles[Math.floor(Math.random() * titles.length)];
            icons.forEach((l) => (l.href = "/favicon-away.svg"));
        } else {
            document.title = original.title;
            icons.forEach((l, i) => (l.href = original.hrefs[i]));
        }
    });
})();
