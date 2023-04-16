javascript:(function(){
  const wg = /(\d+(?:\.\d*)?)\s*?(kgs?)/ig;
  const cm = /(\d+(?:\.\d*)?)\s*?cms?/ig;
  const conversion_factor = 2.20462262;

  function toFeet(cm) {
    var realFeet = ((cm * 0.393700) / 12);
    var feet = Math.floor(realFeet);
    var inches = Math.round((realFeet - feet) * 12);
    return `${feet}&prime;${inches}&Prime;`;
  }

  function kgToLb(match, number, unit) {
    const e = parseFloat(number, 10);
    if (unit.match(/^kgs?$/i)) {
      match += ` (${Math.round(e * conversion_factor)}lbs)`;
    }
    return match
  }

  function fixInnerHTML(node) {
    node.innerHTML = node.innerHTML
      .replace(wg, kgToLb)
      .replace(cm, (match, number) => match + ` (${toFeet(parseFloat(number, 10))})`);
  }

  /* You can't use line comments because it collapses to a single line */
  /* Post body */
  document.querySelectorAll('div.md').forEach(fixInnerHTML);
  /* Post title */
  document.querySelectorAll('p.title a.title').forEach(fixInnerHTML);
})()
