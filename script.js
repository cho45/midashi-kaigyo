
var base = document.getElementById('base');
base.parentNode.removeChild(base);

[
	412 /* Nexus 6P */
	, 375 /* iPhone 6 */
	, 300
	, 290
].forEach(function (n) {
	var diff = base.cloneNode(true);

	var container = diff.querySelector('.container');
	container.style.width = n + 'px';

	var apply = container.cloneNode(true);
	apply.classList.add('apply');
	diff.appendChild(apply);

	document.body.appendChild(diff);
});

function webfontReady (font, opts) {
	if (!opts) opts = {};
	return new Promise(function (resolve, reject) {
		var canvas = document.createElement('canvas');
		var ctx = canvas.getContext('2d');
		var TEST_TEXT = "test.@01N日本語";
		var TEST_SIZE = "100px";

		var timeout = Date.now() + (opts.timeout || 3000);
		(function me () {
			ctx.font = TEST_SIZE + " '" + font + "', sans-serif";
			var w1 = ctx.measureText(TEST_TEXT).width;
			ctx.font = TEST_SIZE + " '" + font + "', serif";
			var w2 = ctx.measureText(TEST_TEXT).width;
			ctx.font = TEST_SIZE + " '" + font + "', monospace";
			var w3 = ctx.measureText(TEST_TEXT).width;
			console.log(w1, w2, w3);
			if (w1 === w2 && w1 === w3) {
				resolve();
			} else {
				if (Date.now() < timeout) {
					setTimeout(me, 100);
				} else {
					reject('timeout');
				}
			}
		})();
	});
}

// ウェブフォントの読みこみを待ってから行う
webfontReady("Sawarabi Mincho").then(function () {
	balance.DEBUG = parseInt(location.hash.substring(1));
	balance(document.querySelectorAll('.apply h1'));
});
