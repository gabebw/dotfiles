javascript: (function () {
  const kgs = /(\d+(?:[.,]\d*)?)\s*?(?:<\/?[^>]+>)*\s*?(?:(kg|kilogram|kilo)s?)/gi;
  const kms = /(\d+(?:[.,]\d*)?)\s*?(?:(km|kilometer)s?)/gi;
  const m_or_cm = /(\d+(?:[.,]\d*)?)\s*?(cm|m)s?\b/gi;
  const one_kilogram_in_lbs = 2.20462262;
  const one_kilometer_in_miles = 0.62150404;

  function parseNumberWithPossibleDecimalComma(s) {
    return parseFloat(s.replace(",", "."), 10);
  }

  /* unit is "cm" or "m" */
  function toFeet(number, unit) {
    const cm = unit === "cm" ? number : unit === "m" ? number * 100 : alert(`Unknown unit: ${unit}`);
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

  function generate(match, input, prettyprinter) {
    const number = parseNumberWithPossibleDecimalComma(input);
    return match + ` (${prettyprinter(number)})`;
  }

  const kgToLb = (match, number) =>
    generate(match, number, (n) => `${Math.round(n * one_kilogram_in_lbs)}lbs`);

  const kmToMiles = (match, number) =>
    generate(
      match,
      number,
      (n) => `${Math.round(n * one_kilometer_in_miles)} miles`
    );

  function fixInnerHTML(node) {
    node.innerHTML = node.innerHTML
      .replace(kgs, kgToLb)
      .replace(kms, kmToMiles)
      .replace(m_or_cm, (entireMatchedString, number, unit) =>
        generate(entireMatchedString, number, (n) => toFeet(n, unit))
      );
  }

  /* You can't use line comments because it collapses to a single line */
  /* Post body */
  document.querySelectorAll("div.md").forEach(fixInnerHTML);
  /* Post title */
  document.querySelectorAll("p.title a.title").forEach(fixInnerHTML);
})();
