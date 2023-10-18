// ==UserScript==
// @name         WaniKani AI Mnemonic Images
// @namespace    aimnemonicimages
// @version      1.9
// @description  Adds AI images to radical, kanji, and vocabulary mnemonics.
// @author       Sinyaven (modified by saraqael, aaron-meyers)
// @license      MIT-0
// @match        https://www.wanikani.com/*
// @match        https://preview.wanikani.com/*
// @require      https://greasyfork.org/scripts/430565-wanikani-item-info-injector/code/WaniKani%20Item%20Info%20Injector.user.js
// @homepageURL  https://community.wanikani.com/t/new-volunteer-project-were-using-ai-to-create-mnemonic-images-for-every-radical-kanji-vocabulary-come-join-us/58234
// @grant        none
// ==/UserScript==

(async function () {
	"use strict";
	/* global $, wkItemInfo */
	/* eslint no-multi-spaces: "off" */

	//////////////
	// settings //
	//////////////

	const ENABLE_RESIZE_BY_DRAGGING = true;
	const USE_THUMBNAIL_FOR_REVIEWS = true;
	const USE_THUMBNAIL_FOR_ITEMINF = false;

	//////////////

	if (!localStorage.getItem("AImnemonicMaxSize")) localStorage.setItem("AImnemonicMaxSize", 400); // standard size
	const folderNames = {
		radical: 'Radicals',
		kanji: 'Kanji',
		vocabulary: 'Vocabulary',
		kanaVocabulary: 'KanaVocabulary',
	}

	function getUrls(wkId, type, mnemonic, thumb = false) {
		// Prefer images specified in user notes if any
		const urlsFromNote = getUrlsFromNote(mnemonic);
		return urlsFromNote ? urlsFromNote :
			['https://wk-mnemonic-images.b-cdn.net/' + type + '/' + mnemonic + '/' + wkId + (thumb ? '-thumb.jpg' : '.png')];
	}

	function getUrlsFromNote(mnemonic) {
		const noteFrame = getNoteFrame(mnemonic);
		if (!noteFrame) {
			return null;
		}
		const note = noteFrame.innerText;
		if (!note) {
			return null;
		}

		const imageUrlRegex = /(http[s]?|[s]?ftp[s]?)(:\/\/)([^\s,]+)(\/)([^\s,]+\.(png|jpg|jpeg))/g;
		if (!note.match(imageUrlRegex)) {
			return null;
		}
		return [...note.matchAll(imageUrlRegex)].map(e => e[0]);
	}

	function getNoteFrame(mnemonic) {
		var noteElementName = null;
		switch (mnemonic) {
			case 'Meaning':
				noteElementName = 'user_meaning_note';
				break;
			case 'Reading':
				noteElementName = 'user_reading_note';
				break;
		}
		if (!noteElementName) {
			return null;
		}

		return window.document.getElementById(noteElementName);
	}

	function init() {
		wkItemInfo.forType("radical,kanji,vocabulary,kanaVocabulary").under("meaning").append("Meaning Mnemonic Image", ({ id, type, on }) => artworkSection(id, type, 'Meaning', on));
		wkItemInfo.forType("radical,kanji,vocabulary,kanaVocabulary").under("reading").append("Reading Mnemonic Image", ({ id, type, on }) => artworkSection(id, type, 'Reading', on));
	}

	async function artworkSection(subjectId, type, mnemonic, page) {
		//console.log(`artworkSection ${subjectId} ${type} ${mnemonic}`);
		const fullType = folderNames[type];
		const isItemInfo = page === 'itemPage';
		const useThumbnail = isItemInfo ? USE_THUMBNAIL_FOR_ITEMINF : USE_THUMBNAIL_FOR_REVIEWS;

		// Wait until note frame is loaded so we can try to load images from notes
		while (true) {
			const noteFrame = getNoteFrame(mnemonic);
			if (noteFrame) {
				//console.log(`${mnemonic} noteFrame preload outerHTML ${noteFrame.outerHTML}`);
				if (noteFrame.loaded)
					await noteFrame.loaded;

				if (noteFrame.complete) {
					const subjectIdRegex = /subject_id=(\d+)/;
					const subjectMatch = noteFrame.src.match(subjectIdRegex);
					//console.log(`${mnemonic} noteFrame is loaded, subjectMatch ${subjectMatch[1]} outerHTML ${noteFrame.outerHTML}`);
					if (subjectMatch && subjectMatch[1] == subjectId) {
						// Expected subject is loaded so we can continue
						//console.log(`subject match on ${subjectId}, breaking`);
						break;
					} else {
						// Note frame has outdated subject, need to wait for new one to load
						//console.log(`subject mismatch on ${subjectId} != ${subjectMatch[1]}, awaiting frame-load`);
					}
				} else {
					// Note frame has not completed loading, need to wait
					//console.log(`${mnemonic} noteFrame is not complete, awaiting frame-load`);
				}
			} else {
				// Note frame has not been added yet, need to wait
				//console.log(`${mnemonic} noteFrame is not found, awaiting frame-load`);
			}
			await new Promise(resolve => document.addEventListener('turbo:frame-load', resolve, { once: true }));
		}

		const imageUrls = getUrls(subjectId, fullType, mnemonic, useThumbnail); // get url (thumbnail in reviews and lessons)

		var div = document.createElement("div");
		for (const imageUrl of imageUrls) {
			const image = document.createElement("img"); // image loading
			if (!(await new Promise(res => {
				image.onload = () => res(true);
				image.onerror = () => res(false);
				image.src = imageUrl;
			}))) return null;

			if (ENABLE_RESIZE_BY_DRAGGING) {
				const currentMax = parseInt(localStorage.getItem("AImnemonicMaxSize")) || 900;
				makeMaxResizable(image, currentMax).afterResize(m => { localStorage.setItem("AImnemonicMaxSize", m); let e = new Event("storage"); e.key = "AImnemonicMaxSize"; e.newValue = m; dispatchEvent(e); });
				addEventListener("storage", e => { if (e.key === "AImnemonicMaxSize") { image.style.maxWidth = `min(${e.newValue}px, 100%)`; image.style.maxHeight = e.newValue + "px"; } });
			}
			div.appendChild(image);
		}
		return div;
	}

	function makeMaxResizable(element, currentMax, lowerBound = 200) {
		let size = 0;
		let max = currentMax;
		let oldMax = currentMax;
		let callback = () => { };
		let pointers = [{ id: NaN, x: 0, y: 0 }]; // image origin is always a pointer (scaling center)

		function getDistanceSum(e) {
			removePointer(e);
			addPointer(e);
			function length(p1, p2) { let d = [p1.x - p2.x, p1.y - p2.y]; return Math.sqrt(d[0] * d[0] + d[1] * d[1]); }
			return pointers.reduce((total, p1) => pointers.reduce((l, p2) => l + length(p1, p2), total), 0);
			//return pointers.reduce(([len, lastP], p) => [len + length(lastP, p), p], [0, pointers[pointers.length - 1]])[0]; // old version using circumference - order dependent! => not usable if pointers.length > 3
		};
		function removePointer(e) {
			if (e) pointers = pointers.filter(p => p.id !== e.pointerId);
		}
		function addPointer(e) {
			if (!e) return;
			let rect = element.getBoundingClientRect();
			pointers.push({ id: e.pointerId, x: e.clientX - rect.left, y: e.clientY - rect.top });
		}
		function startResizing(e) {
			if (e.button !== 0) return;

			if (pointers.length < 2) {
				max = parseFloat(element.style.maxHeight);
				oldMax = max;
			}

			size = getDistanceSum(e);
			element.addEventListener("pointermove", doResizing);
			element.addEventListener("pointerup", endResizing);
			element.addEventListener("pointercancel", cancelResizing);
			element.setPointerCapture(e.pointerId);
			e.preventDefault();
		}
		function doResizing(e) {
			if (!(e.buttons & 1)) return;

			let newSize = getDistanceSum(e);
			max *= newSize / size;
			size = newSize;
			updateMax();
		};
		function endResizing(e) {
			doResizing(e);
			max = Math.min(max, element.parentElement.clientWidth, element.naturalWidth);
			oldMax = Math.max(max, lowerBound);
			cancelResizing(e);
			callback(max);
		}
		function cancelResizing(e) {
			removePointer(e);
			size = getDistanceSum();
			if (pointers.length > 1) return;

			max = oldMax;
			updateMax();
			element.removeEventListener("pointermove", doResizing);
			element.removeEventListener("pointerup", endResizing);
			element.removeEventListener("pointercancel", cancelResizing);
			element.releasePointerCapture(e.pointerId);
		}
		function updateMax() {
			let m = Math.max(max, lowerBound);
			element.style.maxWidth = `min(${m}px, 100%)`;
			element.style.maxHeight = m + "px";
		};
		updateMax();
		element.style.touchAction = "pan-x pan-y";
		element.addEventListener("pointerdown", startResizing);

		return { afterResize: f => { callback = f; } };
	}

	init();
})();
