//  quoting specific blocks from source htmls
document.addEventListener("DOMContentLoaded", function () {
  const parser = new DOMParser();
  const iblocks = document.querySelectorAll("[iblock]");

  iblocks.forEach((iblock) => {

    const href = iblock.getAttribute("href");
    if (href) {
      const [url, refId] = href.split("#");

      fetch(url)
        .then(response => response.text())
        .then(data => {

          const refL = parser.parseFromString(data, "text/html").getElementById(refId);

          if (refL) {
            iblock.innerHTML = refL.innerHTML;
          }
        })
        .catch(error => console.error("Error fetching the content:", error));
    }
  });
});

