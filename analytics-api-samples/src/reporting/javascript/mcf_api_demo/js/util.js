// Copyright 2012 Google Inc. All Rights Reserved.

/* Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @fileoverview This file contains utility classes and functions.
 * @author nafi@google.com (Shahriar Rouf)
 */


/**
 * Returns a string with given string repeated and concatenated.
 * @param {string} str String to be repeated and concatenated.
 * @param {number} times Number of times to be repeated.
 * @return {string} The repeated string.
 */
function repeatAndConcatString(str, times) {
  var ret = [];
  while (times-- > 0) {
    ret.push(str);
  }
  return ret.join('');
}


/**
 * Returns a string presenting a ratio in percentage with '%' sign,
 *     with 2 digits after the decimal point.
 * @param {number} ratio The ratio between 0 to 1.
 * @return {string} The string presenting the ratio.
 */
function getPercentageString(ratio) {
  var inPercent = Math.round(ratio*10000) / 100;
  return inPercent.toString() + ' %';
}


/**
 * Returns a string or number with given character to be padded in front.
 * @param {string} str String to be padded.
 * @param {string} padChar A single character string, the padding character.
 * @param {number} afterPadLength Length of the string after padding.
 * @return {string} The padded string.
 */
function padStringFront(str, padChar, afterPadLength) {
  var times = afterPadLength - str.length;
  var ret = [];
  while (times-- > 0) {
    ret.push(padChar);
  }
  ret.push(str);
  return ret.join('');
}


/**
 * Returns a string or number with given character to be padded in back.
 * @param {string} str String to be padded.
 * @param {string} padChar A single character string, the padding character.
 * @param {number} afterPadLength Length of the string after padding.
 * @return {string} The padded string.
 */
function padStringBack(str, padChar, afterPadLength) {
  var times = afterPadLength - str.length;
  var ret = [str];
  while (times-- > 0) {
    ret.push(padChar);
  }
  return ret.join('');
}


/**
 * Utility class to write an element's inner HTML.
 * @constructor
 * @param {string} elementId Id of the element.
 * @param {boolean} initialVisibility Initial visibility of the element.
 */
function InnerHTMLWriter(elementId, initialVisibility) {
  /** @private */ this.element_ = document.getElementById(elementId);
  if (initialVisibility) {
    this.show();
  } else {
    this.hide();
  }
}


/**
 * Clears innerHTML.
 * @return {!InnerHTMLWriter} This object, allowing for chaining of calls.
 */
InnerHTMLWriter.prototype.clear = function() {
  this.element_.innerHTML = '';
  return this;
};


/**
 * Overwrites innerHTML.
 * @param {string} text InnerHTML will be overwritten by text.
 * @return {!InnerHTMLWriter} This object, allowing for chaining of calls.
 */
InnerHTMLWriter.prototype.set = function(text) {
  this.element_.innerHTML = text + '<br>';
  return this;
};


/**
 * Appends text to innerHTML.
 * @param {string} text InnerHTML will be appended by text.
 * @return {!InnerHTMLWriter} This object, allowing for chaining of calls.
 */
InnerHTMLWriter.prototype.add = function(text) {
  this.element_.innerHTML += text + '<br>';
  return this;
};


/**
 * Determines visibility of the element corresponding to this Writer.
 * @return {boolean} Whether this object is visible.
 */
InnerHTMLWriter.prototype.isVisible = function() {
  return this.element_.style.visibility === '';
};


/**
 * Makes this object visible.
 * @return {!InnerHTMLWriter} This object, allowing for chaining of calls.
 */
InnerHTMLWriter.prototype.show = function() {
  this.element_.style.visibility = '';
  return this;
};


/**
 * Makes this object hidden.
 * @return {!InnerHTMLWriter} This object, allowing for chaining of calls.
 */
InnerHTMLWriter.prototype.hide = function() {
  this.element_.style.visibility = 'hidden';
  return this;
};


/**
 * Utility class for coloring that gives same color to same text everytime.
 * @constructor
 * @param {Array.<string>} presetColors Array of preset color hex strings.
 */
function ColorUtil(presetColors) {
  /**
   * Total colors used.
   * @type {number}
   * @private
   */
  this.totalColorUsed_ = 0;

  /**
   * Array of colors.
   * @type {!Array.<string>}
   * @private
   */
  this.colors_ = [];
  if (presetColors) {
    this.colors_ = presetColors;
  }

  /**
   * Stores mapping of texts to colors.
   * @type {!Object.<string, string>}
   * @private
   */
  this.textToColorMap_ = {};

  /**
   * Stores customized exceptions
   * @type {!Object.<string, function(string=)>}
   * @private
   */
  this.textToCustomFunctionMap_ = {};
}


/**
 * Black color string.
 * @type {string}
 */
ColorUtil.BLACK = '#000000';


/**
 * White color string.
 * @type {string}
 */
ColorUtil.WHITE = '#ffffff';


/**
 * Minimum difference among red, green, blue components of a color.
 * @type {number}
 * @const
 * @private
 */
ColorUtil.minIntraColorDiff_ = 30;


/**
 * Minimum difference among two colors' components.
 * @type {number}
 * @const
 * @private
 */
ColorUtil.minInterColorDiff_ = 15;


/**
 * Adds a customized rule for getting colored text.
 * @param {string} textExact The text to match exactly.
 * @param {!Object.<string, function(): string>} customFunction The customized
 *     function that will be called when text is matched exactly.
 * @return {string} The colored text.
 */
ColorUtil.prototype.addCustomRule = function(textExact, customFunction) {
  if (!this.textToCustomFunctionMap_[textExact]) {
    this.textToCustomFunctionMap_[textExact] = customFunction;
  }
  return this;
};


/**
 * Gets colored text for a given text.
 * @param {string} text The text to color.
 * @return {string} The colored text.
 */
ColorUtil.prototype.getColoredText = function(text) {
  // Assign color at first.
  var coloredText = text.fontcolor(this.getColorFromText(text));
  // If any customized rule is available then use it.
  var customFunction = this.textToCustomFunctionMap_[text];
  if (customFunction) {
    return customFunction();
  }
  return coloredText;
};


/**
 * Gets a mapped color for a given text.
 * @param {string} text The text for whose color is required.
 * @return {string} The color in hex format.
 */
ColorUtil.prototype.getColorFromText = function(text) {
  var color = this.textToColorMap_[text];
  // If color is undefined then create a new mapping.
  if (!color) {
    color = this.getNewColor_();
    // Create a new mapping with the new color.
    this.textToColorMap_[text] = color;
  }
  return color;
};


/**
 * Gets a new color.
 * @return {string} The color.
 * @private
 */
ColorUtil.prototype.getNewColor_ = function() {
  var color = null;
  if (this.totalColorUsed_ < this.colors_.length) {
    color = this.colors_[this.totalColorUsed_];
  } else {
    color = this.getNewRandomColor_();
    this.colors_.push(color);
  }
  ++this.totalColorUsed_;
  return color;
};


/**
 * Gets a new random color that is not gray and not almost similar to previous
 *     colors. In the worst case, it will return 20th non-gray color.
 * @return {string} The color.
 * @private
 */
ColorUtil.prototype.getNewRandomColor_ = function() {
  var mod = 0x1000000;
  var retryCount = 0;
  while (true) {
    var colorValue = (Math.floor(Math.random() * mod)) % mod;
    var color = '#' + padStringFront(colorValue.toString(16), '0', 6);
    if (!this.isAlmostGray_(color)) {
      ++retryCount;
      if (retryCount === 20) {
        return color;
      }
      var isLikePreviousColor = false;
      for (var i = 0; i < this.colors_.length; ++i) {
        if (this.isAlmostSimilar_(color, this.colors_[i])) {
          isLikePreviousColor = true;
          break;
        }
      }
      if (!isLikePreviousColor) {
        return color;
      }
    }
  }
};


/**
 * Decides whether the color is almost gray.
 * @param {string} color The color.
 * @return {boolean} Whether the color is almost gray.
 * @private
 */
ColorUtil.prototype.isAlmostGray_ = function(color) {
  var rgb = this.getColorComponents(color);
  if (Math.abs(rgb[0] - rgb[1]) < ColorUtil.minIntraColorDiff_ &&
      Math.abs(rgb[1] - rgb[2]) < ColorUtil.minIntraColorDiff_ &&
      Math.abs(rgb[2] - rgb[0]) < ColorUtil.minIntraColorDiff_) {
    return true;
  }
  return false;
};


/**
 * Decides whether two colors are almost similar.
 * @param {string} color1 First color.
 * @param {string} color2 Second color.
 * @return {boolean} Whether the colors are almost similar.
 * @private
 */
ColorUtil.prototype.isAlmostSimilar_ = function(color1, color2) {
  var rgb1 = this.getColorComponents(color1);
  var rgb2 = this.getColorComponents(color2);
  for (var i = 0; i < 3; ++i) {
    if (Math.abs(rgb1[i] - rgb2[i]) >= ColorUtil.minInterColorDiff_) {
      return false;
    }
  }
  return true;
};


/**
 * Gets color's red, green, blue components.
 * @param {string} color The color of the format.
 * @return {![number, number, number]} Contains RGB components.
 */
ColorUtil.prototype.getColorComponents = function(color) {
  var colorValue = parseInt(color.substr(1), 16);
  var red = (colorValue & 0xff0000) / 0x10000;
  var green = (colorValue & 0x00ff00) / 0x100;
  var blue = (colorValue & 0x0000ff);
  return [red, green, blue];
};