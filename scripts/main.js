/* language selector */
const languageSet = new Set(['en', 'ru']);

const languageSelector = document.getElementById("language-selector");
languageSelector.value = currentLanguage();
languageSelector.addEventListener("change", changeLanguage);

function currentLanguage() {
    return window.location.href.split("/").filter(e => languageSet.has(e))?.[0];
}

function changeLanguage() {
    let newLanguage = languageSelector.value;
    if (currentLanguage() !== newLanguage) {
	let newURL = window.location.href.split("/").map(e => languageSet.has(e) ? newLanguage : e).join('/');
        window.open(newURL, "_self");
    }
}
