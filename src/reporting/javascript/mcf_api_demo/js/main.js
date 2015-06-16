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
 * Note: auth_util.js and raphael.js are required for this to run.
 * @author nafi@google.com (Shahriar Rouf)
 */

/**
 * Executes a query to the MCF API to retrieve the top conversion source paths
 * with total conversions. Then using raphael.js, the data is visualized.
 * Also path-wise data and tree-wise data are shown.
 */

/**
 * Raphael's javascript library is used for doing visualization.
 * Visit http://raphaeljs.com/ for more information
 * Source: https://raw.github.com/DmitryBaranovskiy/raphael/master/raphael.js
 * License: http://raphaeljs.com/license.html
 */

onerror = handleError;

var DEFAULT_START_DATE = '2012-01-01';
var DEFAULT_END_DATE = '2012-03-31';

var METRICS = 'mcf:totalConversions';
var DIMENSIONS = 'mcf:sourcePath';
var SORT_ORDER = '-mcf:totalConversions';
var MAX_RESULTS = 100;

var SAMPLE_COLORS = [
    '#a0a0a0', '#5687d1', '#cb3e3e', '#6ab975', '#e28751', '#de60ad',
    '#fdda36', '#a173d1', '#9cd2da', '#FF7F50', '#B0E0E6', '#2E8B57'];

var ROOT_NAME = 'root';

var DRAWING_WIDTH = 1200;
var DRAWING_BOUNDARY_GAP = 20;
var DRAWING_RECT_HEIGHT = 60;
var DRAWING_HOVER_TEXT_FONT_SIZE = 16;
// Set this value to 'false' for non-linear visualization.
var DRAWING_LINEAR_ENABLED = true;

var out;
var rowOut;
var dfsOut;


/**
 * Gets called after loading of the Google API Client.js.
 */
function main() {
  initialize();
  handleClientLoad();
}


/**
 * Gives an alert message if any error occurs.
 * @param {string} msg The error message.
 * @param {string} url Url of the error occurrence.
 * @param {number} line Line number of error occurrence.
 */
function handleError(msg, url, line) {
  var text = 'There was an error on this page.\n\n';
  text += 'Error: ' + msg + '\n';
  text += 'URL: ' + url + '\n';
  text += 'Line: ' + line + '\n\n';
  text += 'Click OK to continue.\n\n';
  alert(text);
}


/**
 * Initalizes everything.
 */
function initialize() {
  out = new InnerHTMLWriter('output', true);
  rowOut = new InnerHTMLWriter('row-output', true);
  dfsOut = new InnerHTMLWriter('dfs-output', true);

  document.getElementById('start-date-text-input').value = DEFAULT_START_DATE;
  document.getElementById('end-date-text-input').value = DEFAULT_END_DATE;

  document.getElementById('mcf-api-call-details').innerHTML =
      'This MCF API call will use ' +
      '"<b>' + METRICS + '</b>" as metrics and ' +
      '"<b>' + DIMENSIONS + '</b>" as dimensions.' + '<br>' +
      'This will demonstrate comparison of <b>total conversions</b> ' +
      'among different <b>source paths</b>.';

  document.getElementById('show-row-output-checkbox').checked =
      rowOut.isVisible();
  document.getElementById('show-dfs-output-checkbox').checked =
      dfsOut.isVisible();
}


/**
 * Makes query to MCF API. This gets called after clicking the 'Run Demo'
 *     button.
 */
function makeMcfApiCall() {
  out.set('<b>Querying MCF</b>');

  // Table ID is of the form 'ga:xxx' where 'xxx' is your profile ID.
  var tableId = document.getElementById('table-id-text-input').value;
  var startDate = document.getElementById('start-date-text-input').value;
  var endDate = document.getElementById('end-date-text-input').value;

  gapi.client.analytics.data.mcf.get({
    'ids': tableId,
    'start-date': startDate,
    'end-date': endDate,
    'metrics': METRICS,
    'dimensions': DIMENSIONS,
    'sort': SORT_ORDER,
    'max-results': MAX_RESULTS
  }).execute(handleMcfApiResponse);
}


/**
 * Handles with raw MCF API response.
 * @param {!Object} response MCF API response.
 */
function handleMcfApiResponse(response) {
  if (!response.error) {
    if (response.rows && response.rows.length) {
      out.add(response.totalResults + ' results found');
      out.add(response.rows.length + ' rows fetched');

      // Create a color utility with some initial colors.
      var colorUtil = new ColorUtil(SAMPLE_COLORS);
      colorUtil.addCustomRule('google', getColoredGoogleText);

      var treeRoot = getTreeRootFromResponse(response);
      treeRoot.colorTree(colorUtil);

      if (document.getElementById('show-row-output-checkbox').checked) {
        rowOut.set('<hr>')
            .add(generateRowWiseData(response, colorUtil))
            .show();
      }

      if (document.getElementById('show-dfs-output-checkbox').checked) {
        dfsOut.set('<hr>')
            .add('<b>DFS Traversal of Tree Data:</b>')
            .add(generateDFSData(treeRoot))
            .show();
      }

      document.getElementById('button-pane').innerHTML = '';
      setTimeout('out.clear()', 2000);

      var visualizer = new Visualizer(
          treeRoot,
          DRAWING_WIDTH,
          DRAWING_BOUNDARY_GAP,
          DRAWING_RECT_HEIGHT,
          DRAWING_HOVER_TEXT_FONT_SIZE,
          'Chart:',
          'drawingheader',
          'drawing',
          DRAWING_LINEAR_ENABLED);
      visualizer.draw();
    } else {
      out.add('No results found.');
    }
  } else {
    out.add('There was an error querying MCF API: ' + response.message)
        .add(JSON.stringify(response));
  }
}


/**
 * TreeNode class to store path, count and drawing information in a
 *     tree data structure.
 * @constructor
 * @param {string} sourceName The source name.
 * @param {number} totalConversions The total conversions.
 */
function TreeNode(sourceName, totalConversions) {
  /**
   * Source name.
   * @type {string}
   * @const
   */
  this.sourceName = sourceName;

  /**
   * Colored source name.
   * @type {string}
   */
  this.coloredText = sourceName;

  /**
   * Basic color.
   * @type {string}
   */
  this.color = ColorUtil.BLACK;

  /**
   * Total conversions upto at least this tree-node.
   * @type {number}
   */
  this.totalConversions = totalConversions;

  /**
   * Parent tree-node.
   * @type {TreeNode}
   */
  this.parent = null;

  /**
   * Children tree-nodes.
   * @type {!Array.<!TreeNode>}
   */
  this.children = [];

  /**
   * Stores mapping of source names to child tree-nodes.
   * @type {!Object.<string, !TreeNode>}
   * @private
   */
  this.sourceNameToChildMap_ = {};

  /**
   * Cached root of this tree-node.
   * @type {TreeNode}
   * @private
   */
  this.root_ = null;

  /**
   * Cached height of the subtree rooted at this tree-node.
   * @type {number}
   * @private
   */
  this.height_ = -1;

  /**
   * Cached depth of this tree-node.
   * @type {number}
   * @private
   */
  this.depth_ = -1;

  /**
   * Cached sum of total conversions of the children.
   * @type {number}
   * @private
   */
  this.childrenConversionSum_ = -1;

  /**
   * Required information for visualizing this tree-node
   * @type {!Object}
   */
  this.draw = {
    /**
     * The rectangle
     * @type {Raphael.Element}
     */
    rect: null,
    /**
     * The text box for hover text.
     * @type {Raphael.Element}
     */
    text: null,
    colors: {
      normal: {
        /** @type {string} */ fill: null,
        /** @type {string} */ stroke: null
      },
      hover: {
        /** @type {string} */ fill: null,
        /** @type {string} */ stroke: null
      }
    }
  };
}


/**
 * Accepts a tree-node as a child and update its children information and
 *     then returns the child tree-node.
 * @param {!TreeNode} treeNode The tree-node to add or update as a child
 * @return {!TreeNode} The child tree-node added or updated.
 */
TreeNode.prototype.addOrUpdateChildAndAugment = function(treeNode) {
  var childTreeNode = this.sourceNameToChildMap_[treeNode.sourceName];
  if (childTreeNode) {
    // If the child exists, update its total conversion count.
    childTreeNode.totalConversions += treeNode.totalConversions;
  } else {
    // If the child does not exist, add it in children.
    this.addChild(treeNode);
    childTreeNode = treeNode;
  }
  return childTreeNode;
};


/**
 * Adds a tree-node as a child.
 * @param {!TreeNode} treeNode The child tree-node to add.
 * @return {!TreeNode} This object, allowing for chaining of calls.
 */
TreeNode.prototype.addChild = function(treeNode) {
  treeNode.parent = this;
  this.children.push(treeNode);
  this.sourceNameToChildMap_[treeNode.sourceName] = this.children[this.children.length - 1];
  return this;
};


/**
 * Gets sum of total conversions of the children.
 * @return {number} The sum of total conversions.
 */
TreeNode.prototype.getChildrenConversionSum = function() {
  if (this.childrenConversionSum_ !== -1) {
    return this.childrenConversionSum_;
  }
  this.childrenConversionSum_ = 0;
  for (var i = 0; i < this.children.length; ++i) {
    this.childrenConversionSum_ += this.children[i].totalConversions;
  }
  return this.childrenConversionSum_;
};


/**
 * Decides whether this is a leaf tree-node.
 * @return {boolean} Whether this is a leaf tree-node.
 */
TreeNode.prototype.isLeaf = function() {
  return this.children.length === 0;
};


/**
 * Gets a child or null of this tree-node.
 * @param {number} index The 0-based index of the child to get.
 * @return {TreeNode} The required child or null if not present.
 */
TreeNode.prototype.getChild = function(index) {
  if (0 <= index && index < this.children.length) {
    return this.children[index];
  }
  return null;
};


/**
 * Decides whether this is the root.
 * @return {boolean} Whether this is the root.
 */
TreeNode.prototype.isRoot = function() {
  return this.parent === null;
};


/**
 * Gets root of this tree-node.
 * @return {!TreeNode} Root of this tree-node.
 */
TreeNode.prototype.getRoot = function() {
  if (this.root_ !== null) {
    return this.root_;
  }
  if (this.isRoot()) {
    this.root_ = this;
  } else {
    this.root_ = this.parent.getRoot();
  }
  return this.root_;
};


/**
 * Gets height of the sub-tree rooted at this tree-node.
 * @return {number} Height of the sub-tree rooted at this tree-node.
 */
TreeNode.prototype.getHeight = function() {
  if (this.height_ !== -1) {
    return this.height_;
  }
  this.height_ = 0;
  for (var i = 0; i < this.children.length; ++i) {
    this.height_ = Math.max(this.height_, this.children[i].getHeight() + 1);
  }
  return this.height_;
};


/**
 * Gets depth of this tree-node.
 * @return {number} Depth of this tree-node.
 */
TreeNode.prototype.getDepth = function() {
  if (this.depth_ !== -1) {
    return this.depth_;
  }
  if (this.isRoot()) {
    this.depth_ = 0;
  } else {
    this.depth_ = this.parent.getDepth() + 1;
  }
  return this.depth_;
};


/**
 * Gets the ratio of total conversions for this tree-node to sum of all
 *     conversions.
 * @return {number} Percentage of total conversions for this tree-node.
 */
TreeNode.prototype.getConversionsRatio = function() {
  return this.totalConversions / this.getRoot().totalConversions;
};


/**
 * Updates all ancestor tree-nodes.
 * @param {function(!TreeNode)} updaterFunction Updater function for tree-nodes.
 * @param {boolean=} opt_updateThis Whether to update this node itself.
 */
TreeNode.prototype.updateAncestors = function(updaterFunction, opt_updateThis) {
  if (updaterFunction != null) {
    // by default update this node.
    if (opt_updateThis === undefined || opt_updateThis === true) {
      updaterFunction(this);
    }
    if (!this.isRoot()) {
      this.parent.updateAncestors(updaterFunction, true);
    }
  }
};


/**
 * Updates all descendant tree-nodes.
 * @param {function(!TreeNode)} updaterFunction Updater function for tree-nodes.
 * @param {boolean=} opt_updateThis Whether to update this node itself.
 */
TreeNode.prototype.updateDescendants =
    function(updaterFunction, opt_updateThis) {
  if (updaterFunction != null) {
    // by default update this node.
    if (opt_updateThis === undefined || opt_updateThis === true) {
      updaterFunction(this);
    }
    for (var i = 0; i < this.children.length; ++i) {
      this.children[i].updateDescendants(updaterFunction, true);
    }
  }
};


/**
 * Adds color to all descendant tree-nodes.
 * @param {ColorUtil} colorUtil Utility thats gives same colors to same texts.
 */
TreeNode.prototype.colorTree = function(colorUtil) {
  this.color = colorUtil.getColorFromText(this.sourceName);
  this.coloredText = colorUtil.getColoredText(this.sourceName);
  for (var i = 0; i < this.children.length; ++i) {
    this.children[i].colorTree(colorUtil);
  }
};


/**
 * Parses and converts MCF API response into a tree and returns the root.
 * @param {!Object} response MCF API response.
 * @return {!TreeNode} Contains the root of the tree.
 */
function getTreeRootFromResponse(response) {
  var rows = response.rows;

  // Create the root tree-node.
  var sumTotalConversions = response.totalsForAllResults['mcf:totalConversions'];
  var treeRoot = new TreeNode(ROOT_NAME, sumTotalConversions);

  // For each row, process the path.
  for (var r = 0; r < rows.length; r++) {
    var path = rows[r][0].conversionPathValue;
    var totalConversions = parseInt(rows[r][1].primitiveValue);
    var currentTreeNode = treeRoot;

    // For each element in the path, update tree information.
    for (var i = 0; i < path.length; ++i) {
      var nextTreeNode = new TreeNode(path[i].nodeValue, totalConversions);
      currentTreeNode =
          currentTreeNode.addOrUpdateChildAndAugment(nextTreeNode);
    }
  }
  return treeRoot;
}


/**
 * Returns a colored 'Google' string.
 * @return {string} Colored 'Google' string.
 */
function getColoredGoogleText() {
  var googleChars = ['G', 'o', 'o', 'g', 'l', 'e'];
  var googleColors =
      ['#3369E8', '#D50F25', '#EEB211', '#3369E8', '#009925', '#D50F25'];
  var googleColoredChars = [];
  for (var i = 0; i < googleChars.length; ++i) {
    googleColoredChars.push(googleChars[i].fontcolor(googleColors[i]));
  }
  return googleColoredChars.join('');
}


/**
 * Generates Row-wise data from MCF API response.
 * @param {!Object} response MCF API response.
 * @param {!ColorUtil} colorUtil Utility thats gives same colors to same texts.
 * @return {string} Contains a table of conversion paths and total conversions.
 */
function generateRowWiseData(response, colorUtil) {
  var rowWiseData = [];
  // Add profile Name.
  rowWiseData.push('Profile Name: ', response.profileInfo.profileName, '<br>');

  var table = ['<table>'];
  // Put headers in table.
  table.push('<tr>');
  table.push('<th>', 'Row', '</th>');
  for (var i = 0; i < response.columnHeaders.length; ++i) {
    var currentHeader = response.columnHeaders[i];
    table.push('<th>', currentHeader.name, '</th>');
  }
  table.push('<th>', 'Percentage', '</th>');
  table.push('</tr>');

  var sumTotalConversions = response.totalsForAllResults['mcf:totalConversions'];
  // Put cells in table.
  for (var i = 0; i < response.rows.length; ++i) {
    var currentRow = response.rows[i];
    var totalConversions = parseInt(currentRow[1].primitiveValue);
    table.push('<tr>');
    table.push('<td>', (i + 1), '</td>');
    table.push('<td>', generatePathString(currentRow[0], colorUtil), '</td>');
    table.push('<td>', totalConversions, '</td>');
    table.push('<td>',
        getPercentageString(totalConversions / sumTotalConversions), '</td>');
    table.push('</tr>');
  }
  table.push('</table>');
  rowWiseData.push(table.join(''));
  return rowWiseData.join('');
}


/**
 * Generates path string out of column-0.
 * @param {!Object} column0 Column-0 of a MCF API response row.
 * @param {!ColorUtil} colorUtil Utility thats gives same colors to same texts.
 * @return {string} string of the form 'src1 --> src2 --> ... --> srcN'.
 */
function generatePathString(column0, colorUtil) {
  var pathPieces = [];
  var conversionPath = column0.conversionPathValue;
  for (var i = 0; i < conversionPath.length; ++i) {
    var sourceName = conversionPath[i].nodeValue;
    pathPieces.push(colorUtil.getColoredText(sourceName).bold());
  }
  return pathPieces.join(' --> ');
}


/**
 * Recursively traverses the tree in preorder and generates tree information.
 * @param {!TreeNode} treeNode The tree-node currently in.
 * @return {string} The tree presentation rooted at 'tree-node'.
 */
function generateDFSData(treeNode) {
  var treePieces = [];
  var treeNodePieces = [];
  treeNodePieces.push(repeatAndConcatString('-- ', treeNode.getDepth()));
  treeNodePieces.push(treeNode.coloredText.bold(), ' | ');
  treeNodePieces.push(treeNode.totalConversions, ' | ');
  treeNodePieces.push(getPercentageString(treeNode.getConversionsRatio()));
  treeNodePieces.push('<br>');
  treePieces.push(treeNodePieces.join(''));
  // For each child add its tree presentation.
  for (var i = 0; i < treeNode.children.length; ++i) {
    treePieces.push(generateDFSData(treeNode.children[i]));
  }
  return treePieces.join('');
}
