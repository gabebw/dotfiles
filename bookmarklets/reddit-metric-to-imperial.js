javascript: (function () {
  const wg = /(\d+(?:\.\d*)?)\s*?(?:(kg|kilo)s?)/gi;
  const cm = /(\d+(?:\.\d*)?)\s*?cms?/gi;
  const conversion_factor = 2.20462262;

  function toFeet(cm) {
    const realInches = cm * 0.3937;
    if (realInches < 48) {
      /* Assume this is not height, but something else: use inches */
      return `${Math.floor(realInches)}&Prime;`;
    } else {
      const realFeet = realInches / 12;
      const feet = Math.floor(realFeet);
      const inches = Math.round((realFeet - feet) * 12);
      return `${feet}&prime;${inches}&Prime;`;
    }
  }

  function kgToLb(match, number, unit) {
    const e = parseFloat(number, 10);
    match += ` (${Math.round(e * conversion_factor)}lbs)`;
    return match;
  }

  function fixInnerHTML(node) {
    node.innerHTML = node.innerHTML
      .replace(wg, kgToLb)
      .replace(
        cm,
        (match, number) => match + ` (${toFeet(parseFloat(number, 10))})`
      );
  }

  /* You can't use line comments because it collapses to a single line */
  /* Post body */
  document.querySelectorAll("div.md").forEach(fixInnerHTML);
  /* Post title */
  document.querySelectorAll("p.title a.title").forEach(fixInnerHTML);
})();
