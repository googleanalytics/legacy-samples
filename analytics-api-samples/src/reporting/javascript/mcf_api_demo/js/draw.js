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
 * @fileoverview Sample program uses a profile id to query the MCF API to
 * retrieve the top conversion source paths with total conversions.
 * Note: raphael.js is required for this to run.
 * @author nafi@google.com (Shahriar Rouf)
 */

/**
 * Using raphael.js, MCF API data is visualized.
 */

/**
 * Raphael's javascript library is used for doing visualization.
 * Visit http://raphaeljs.com/ for more information
 * Source: https://raw.github.com/DmitryBaranovskiy/raphael/master/raphael.js
 * License: http://raphaeljs.com/license.html
 */


/**
 * @constructor
 * @param {!TreeNode} treeRoot The root of the tree data structure.
 * @param {number} drawWidth Width of the drawing.
 * @param {number} gap Gaps around the drawing.
 * @param {number} rectHeight Height of each rectangles in the drawing.
 * @param {number} hoverTextFontSize Font size for hover texts in the drawing.
 * @param {?string} title Title of the drawing.
 * @param {?string} titleElementId Element id for the title.
 * @param {string} drawingElementId Element id for the drawing.
 * @param {boolean} linearDrawingEnabled Whether linear drawing is enabled.
 */
function Visualizer(treeRoot, drawWidth, gap, rectHeight, hoverTextFontSize,
    title, titleElementId, drawingElementId, linearDrawingEnabled) {
  /**
   * The root of the tree data structure.
   * @type {!TreeNode}
   * @private
   */
  this.treeRoot_ = treeRoot;

  /**
   * Gaps around the drawing.
   * @type {number}
   * @const
   * @private
   */
  this.gap_ = gap;

  /**
   * Height of each rectangles in the drawing.
   * @type {number}
   * @const
   * @private
   */
  this.rectHeight_ = rectHeight;

  /**
   * Width of the drawing.
   * @type {number}
   * @const
   * @private
   */
  this.drawWidth_ = drawWidth;

  /**
   * Height of the drawing.
   * @type {number}
   * @const
   * @private
   */
  this.drawHeight_ = this.rectHeight_ * (treeRoot.getHeight() + 3);

  /**
   * Width of the Raphael paper.
   * @type {number}
   * @const
   * @private
   */
  this.paperWidth_ = this.drawWidth_ + 2 * this.gap_;

  /**
   * Height of the Raphael paper.
   * @type {number}
   * @const
   * @private
   */
  this.paperHeight_ = this.drawHeight_ + 2 * this.gap_;

  /**
   * Font size for hover texts in the drawing.
   * @type {number}
   * @const
   * @private
   */
  this.hoverTextFontSize_ = hoverTextFontSize;

  // Set the header of the paper.
  if (title !== null && titleElementId !== null) {
    document.getElementById(titleElementId).innerHTML =
        '<h2>' + title + '</h2>';
  }

  /**
   * Whether linear drawing is enabled.
   * @type {boolean}
   * @const
   * @private
   */
  this.linearDrawingEnabled_ = linearDrawingEnabled;

  /**
   * The Raphael paper object.
   * @type {!Raphael}
   * @private
   */
  this.raphaelPaper_ = new Raphael(document.getElementById(drawingElementId),
      this.paperWidth_, this.paperHeight_);
}


/**
 * Minimum Span size for rectangles.
 * @type {number}
 * @const
 * @private
 */
Visualizer.prototype.minimumSpan_ = 2;


/**
 * Draws the visualization. Modifies 'draw' attributes of all TreeNodes.
 */
Visualizer.prototype.draw = function() {
  // Draw a thin black border.
  this.raphaelPaper_.rect(1, 1, this.paperWidth_ - 2, this.paperHeight_ - 2)
      .attr({'fill': ColorUtil.WHITE, 'stroke': ColorUtil.BLACK});

  // Recursively draw the visualization of our data.
  this.drawRecursive_(this.treeRoot_, this.gap_, this.gap_,
      this.drawWidth_, '');
};


/**
 * Converts a ratio in [0, 1] linearly/nonlinearly to [0, 1].
 * @param {number} ratio Ratio from 0 to 1.
 * @return {number} The converted ratio between 0 to 1.
 * @private
 */
Visualizer.prototype.getRatio_ = function(ratio) {
  if (this.linearDrawingEnabled_) {
    return ratio;
  }
  return Math.log(1 + ratio * (Math.exp(1) - 1));
};


/**
 * Recursively draws a subtree rooted at 'tree-node'.
 * <ul>
 * <li>Prepares source path for the tree-node.
 * <li>Prepares colors for rectangle.
 * <li>Draws rectangle for the tree-node and add mouse event handlers.
 * <li>Calculates span for child subtrees.
 * <li>Calculates weights for each child subtree based on conversions and
 *     <ul>
 *     <li>Allocates span to that child subtree according to this weight
 *     </ul>
 * <li>For each child, draw the subtree recursively
 * </ul>
 * @param {!TreeNode} treeNode The current drawn tree-node.
 * @param {number} cx Starting 'x' for this sub-drawing.
 * @param {number} cy Starting 'y' for this sub-drawing.
 * @param {number} span Span along X-axis for this sub-drawing.
 * @param {string} path Path string from root to this tree-node.
 * @private
 */
Visualizer.prototype.drawRecursive_ = function(treeNode, cx, cy, span, path) {
  // If span becomes too low give a minimum size
  if (span < Visualizer.prototype.minimumSpan_) {
    span = Visualizer.prototype.minimumSpan_;
  }

  // Append current tree-node's source-name into path.
  // No need to add 'root' in the display path.
  var nextPathPieces = [path];
  if (!treeNode.isRoot()) {
    if (path !== '') {
      nextPathPieces.push(' > ');
    }
    nextPathPieces.push(treeNode.sourceName);
  }
  path = nextPathPieces.join('');

  // Construct hover text to show for the rectangle of this tree-node.
  var hoverTextPieces = [];
  if (!treeNode.isRoot()) {
    hoverTextPieces.push('Source-path: ', path, '\n');
  } else {
    hoverTextPieces.push('All source-paths\n');
  }
  hoverTextPieces.push('Conversions: ', treeNode.totalConversions, '\n');
  hoverTextPieces.push(getPercentageString(treeNode.getConversionsRatio()));

  // Create a hover text box for this tree-node. Keep it hidden initially.
  treeNode.draw.text = this.raphaelPaper_.text(0, 0, hoverTextPieces.join(''))
      .attr({'font-size': this.hoverTextFontSize_})
      .toBack()
      .hide();

  var rgb = treeNode.color;
  var hsb = Raphael.rgb2hsb(rgb);
  var h = hsb.h;
  var s = hsb.s;
  var b = hsb.b;

  // Create highlight colors for the tree-node's rectangle.
  treeNode.draw.colors.hover.fill = rgb;
  treeNode.draw.colors.hover.stroke = rgb;
  // Create normal colors for the tree-node's rectangle.
  treeNode.draw.colors.normal.fill =
      Raphael.hsb(h, s * .5, Math.min(.9, b * 2));
  treeNode.draw.colors.normal.stroke =
      Raphael.hsb(h, s * .5, Math.min(.9, b * 2));

  // Create a rectangle for this tree-node.
  this.drawRectangle_(treeNode, cx, cy, span);

  // Calculate total span for all children
  var totalSpanForChildren;
  if (this.linearDrawingEnabled_) {
    totalSpanForChildren = Math.round(span * treeNode.getChildrenConversionSum()
        / treeNode.totalConversions);
  } else {
    totalSpanForChildren = span;
  }

  // Calculate relative weight of each child.
  var totalWeight = 0;
  var weights = [];
  for (var i = 0; i < treeNode.children.length; ++i) {
    weights[i] = this.getRatio_(treeNode.children[i].getConversionsRatio());
    totalWeight += weights[i];
  }

  // Keep track of how much of 'x' you have passed.
  var passx = 0;
  // Draw subtrees recursively, for each child.
  for (var i = 0; i < treeNode.children.length; ++i) {
    var subTreeSpan =
        Math.round(weights[i] / totalWeight * totalSpanForChildren);
    this.drawRecursive_(treeNode.children[i], cx + passx, cy + this.rectHeight_,
        subTreeSpan, path);
    // Add the amount of 'x' used up by this child (and its subtree).
    passx += subTreeSpan;
  }
};


/**
 * Draws a rectangle and adds mouse event listeners.
 * @param {!TreeNode} treeNode The tree-node for which rectangle will be drawn.
 * @param {number} cx Starting 'x' for this rectangle.
 * @param {number} cy Starting 'y' for this rectangle.
 * @param {number} span Span along X-axis for this rectangle.
 * @private
 */
Visualizer.prototype.drawRectangle_ = function(treeNode, cx, cy, span) {
  // In Raphaël JavaScript Library, upwards is negative Y direction. So, it
  //     adjusts the y value by subtracting it from paper-height.
  treeNode.draw.rect = this.raphaelPaper_
      .rect(cx, this.paperHeight_ - cy - this.rectHeight_ - 1,
          span - 1, this.rectHeight_ - 1);
  unhighlightTreeNode(treeNode);
  this.addMouseOverListener_(treeNode);
  this.addMouseOutListener_(treeNode);
  this.addMouseMoveListener_(treeNode);
};


/**
 * Adds a listener function to mouse over event.
 * @param {!TreeNode} treeNode Tree-node corresponding to the rectangle for
 *     which handler will be added.
 * @private
 */
Visualizer.prototype.addMouseOverListener_ = function(treeNode) {
  treeNode.draw.rect.mouseover(function(e) {
    // Show the hover text
    treeNode.draw.text.toFront().show();
    // highlight the path
    treeNode.updateAncestors(highlightTreeNode);
  });
};


/**
 * Adds a listener function to mouse out event.
 * @param {!TreeNode} treeNode Tree-node corresponding to the rectangle for
 *     which handler will be added.
 * @private
 */
Visualizer.prototype.addMouseOutListener_ = function(treeNode) {
  treeNode.draw.rect.mouseout(function(e) {
    // Hide the hover text
    treeNode.draw.text.toBack().hide();
    // unhighlight the path
    treeNode.updateAncestors(unhighlightTreeNode);
  });
};


/**
 * Adds a listener function to mouse move event.
 * @param {!TreeNode} treeNode Tree-node corresponding to the rectangle for
 *     which handler will be added.
 * @private
 */
Visualizer.prototype.addMouseMoveListener_ = function(treeNode) {
  /** 'this' becomes invalid inside the inner function.
   *     So, 'this.paperWidth_' is unavailable.
   *     Make a local copy first.
   * @type {number}
   */
  var paperWidth = this.paperWidth_;

  treeNode.draw.rect.mousemove(function(e) {
    var boxW = treeNode.draw.text.getBBox().width + 10; // 10 as some padding
    var boxH = treeNode.draw.text.getBBox().height;

    // co-ordinates for the text box
    var textX;
    var textY = e.offsetY - boxH;

    // calculate the 'textX' so that the text does not crosses any border
    if (e.offsetX - boxW / 2 < 0) {
      // hitting left border
      textX = boxW / 2;
    } else if (e.offsetX + boxW / 2 > paperWidth) {
      // hitting right border
      textX = paperWidth - boxW / 2;
    } else {
      // otherwise, follow the event 'x'
      textX = e.offsetX;
    }

    // Update co-ordinates of the text box
    treeNode.draw.text.attr({'x': textX, 'y': textY}).toFront().show();
  });
};


/**
 * Highlights the rectangle corresponding to a tree-node.
 * @param {!TreeNode} treeNode Tree-node corresponding to the rectangle that
 *     will be highlighted.
 */
function highlightTreeNode(treeNode) {
  treeNode.draw.rect.attr({
      'fill': treeNode.draw.colors.hover.fill,
      'stroke': treeNode.draw.colors.hover.stroke});
}


/**
 * Unhighlights the rectangle corresponding to a tree-node.
 * @param {!TreeNode} treeNode Tree-node corresponding to the rectangle that
 *     will be unhighlighted.
 */
function unhighlightTreeNode(treeNode) {
  treeNode.draw.rect.attr({
      'fill': treeNode.draw.colors.normal.fill,
      'stroke': treeNode.draw.colors.normal.stroke});
}
