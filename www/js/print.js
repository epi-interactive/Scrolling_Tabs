/*// Tweaks for plotly charts. 

// When theres a change in the DOM from either the inial load of the page or a change in data, 
// get the plot svg and the bars that are a part of the SVG.

setTimeout(function() {
  let bars = document.querySelectorAll(".charts-main .barlayer");
  let plots = document.querySelectorAll(".charts-main .plot");
  let totalErrorBar = document.querySelector(".timeseries .bars .errorbar");
  // If the elements exist, by removing and reattaching the bars from the plot it puts the bars in front of the mean line
  if(plots.length > 0 && bars.length > 0){
    plots.forEach(function(el, i){
        el.removeChild(bars[i]);
  	    el.appendChild(bars[i]);
  });
  }
  // Also, disable the legend click events by cloning the legend and replacing the existing one.
  let legend = document.querySelector(".funnel-chart-wrapper .legend");
  if(legend !== null){
    var newLegend = legend.cloneNode(true);
    legend.parentNode.replaceChild(newLegend, legend);

  }
  
  // Remove errorbars on Total timeseries bar
  if(totalErrorBar !== null){
    totalErrorBar.style.display = "none";
  }
    
}, 2000);


const hidePrintModal = function() {
	const modal = document.querySelector(".print-view-modal");
	modal.style.right = "-500px";
	setTimeout(function(){
		modal.style.display = "none";
    }, 1000);
};



navigator.sayswho= (function(){
    var ua= navigator.userAgent, tem, 
    M= ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) || [];
    if(/trident/i.test(M[1])){
        tem=  /\brv[ :]+(\d+)/g.exec(ua) || [];
        return 'IE '+(tem[1] || '');
    }
    if(M[1]=== 'Chrome'){
        tem= ua.match(/\b(OPR|Edge)\/(\d+)/);
        if(tem!= null) return tem.slice(1).join(' ').replace('OPR', 'Opera');
    }
    M= M[2]? [M[1], M[2]]: [navigator.appName, navigator.appVersion, '-?'];
    if((tem= ua.match(/version\/(\d+)/i))!= null) M.splice(1, 1, tem[1]);
    return M.join(' ');
})();

console.log(navigator.sayswho);


const printDocument = function() {
  const browser = navigator.sayswho;
  
  if(browser.indexOf("IE") > -1) {
    document.querySelector(".main-container").style.padding = 0;
  }
  window.print();
  if(browser.indexOf("IE") > -1) {
    document.querySelector(".main-container").style.padding = "1.6cm";
  }
};



  */
  
  
  
if (!Array.prototype.find) {
  Array.prototype.find = function(predicate) {
    if (this == null) {
      throw new TypeError('Array.prototype.find called on null or undefined');
    }
    if (typeof predicate !== 'function') {
      throw new TypeError('predicate must be a function');
    }
    var list = Object(this);
    var length = list.length >>> 0;
    var thisArg = arguments[1];
    var value;

    for (var i = 0; i < length; i++) {
      value = list[i];
      if (predicate.call(thisArg, value, i, list)) {
        return value;
      }
    }
    return undefined;
  };
}



// Throtte function to limit the amount of times the functions firing from 
// window.onscroll actuall fire.
//
// https://www.sitepoint.com/throttle-scroll-events/
const throttle = function(callback, wait) {
  var time = Date.now();
  return function() {
    if ((time + wait - Date.now()) < 0) {
      callback();
      time = Date.now();
    }
  };
};

window.onscroll = throttle(function() {
  // Get the elements we need for the checks 
  // and only run the functions if they're not undefined
   
  let bars = document.querySelectorAll(".charts-main .barlayer");
  let plots = document.querySelectorAll(".charts-main .plot");
  let legend = document.querySelector(".funnel-chart-wrapper .legend");
  let totalErrorBar = document.querySelector(".timeseries .bars .errorbar");
  const lines = document.querySelectorAll(".charts-main .scatterlayer .trace .js-line");
  const indModal = document.querySelector("#modal-exploreIndicators-indOverview");
  const regModal = document.querySelector("#modal-myRegion-regionOverview");
  
  if(bars){
    if(bars.length > 0) {
      bringBarsToFront(bars, plots);
    }
  }
  if(legend) {
    disableFunnelLegend(legend);
  }
  if(lines) {
    if(lines.length > 0) {
      extendMeanLines(lines);
    }
  }
  if(totalErrorBar){
    hideTotalErrorBar(totalErrorBar);
  }
 
}, 1500);

const bringBarsToFront = function(bars, plots) {
  if(plots.length > 0 && bars.length > 0){
    for(let i = 0; i < plots.length; i++){
      let el = plots[i];
      el.removeChild(bars[i]);
	    el.appendChild(bars[i]);
    }
  }
};


const disableFunnelLegend = function(legend) {
  if(legend !== null){
    var newLegend = legend.cloneNode(true);
    legend.parentNode.replaceChild(newLegend, legend);
  }
};

const extendMeanLines = function(lines) {
  for(let i = 0; i < lines.length; i++){
    const line = lines[i];
    if(line) {
      extendLine(line);
    }
  }
};

const hideTotalErrorBar = function(totalErrorBar) {
    totalErrorBar.style.display = "none";
};

const handleOverviewPositioning = function() {

  if(indModal !== null) {
    listenForModalClose(indModal);
  } if(regModal !== null){
    listenForModalClose(regModal);
  }
};


// Age Groups and Ethnicity Groups for the national table in Explore Indicators
const ageGroups = ["18-49 years", "50-59 years", "60-74 years", "75 years and over"];
const ethGroups = ["Māori", "Pacific", "Asian", "European/Other"];


// If theres click on a row containing a group mentioned above, expand/collapse the following rows accordingly
$(document.body).on("click", function(e) {
  const table = document.querySelector(".national-table");
  if(table){
    const target = e.target;
    if(target.localName === "td"){
      const parent = target.parentNode;
      if(ageGroups.concat(ethGroups).find(function(el){ return el === target.innerText })){
       changeRows(parent); 
      }
    }
  }
});


const getChildRows = function (row) {
  
  const text = row.children[0].innerText;
  
  const a = row.nextSibling;
  const b = a.nextSibling;
  const c = b.nextSibling;
  const d = c.nextSibling;
  const siblings = [a,b,c,d];
  
  const reduced = siblings.filter(function(el) {
    return el.children[0].innerText.indexOf(text) > -1;
  });
  return reduced;
};


// Expand/collapse "child" rows 
const changeRows = function(row) {
  
  // Get the "child" rows
  const siblings = getChildRows(row);
  
  // If they're collapsed, then expand them and change the icons around
  if(row.nextSibling.style.display === "none"){
    siblings.forEach(function(el){
      el.style.display = "table-row";
      row.children[0].classList.remove("plus");
      row.children[0].classList.add("minus");
      
    });
  } else {
    // Do the inverse if they're expanded already
    siblings.forEach(function(el) {
      el.style.display = "none";
      row.children[0].classList.remove("minus");
      row.children[0].classList.add("plus");
    });
  }
};

// jQuery script to check whether an element exists in the DOM yet
var waitForEl = function(selector, callback) {
  console.log("waiting...");
  if (jQuery(selector).length) {
    callback();
  } else {
    setTimeout(function() {
      waitForEl(selector, callback);
    }, 100);
  }
};



// When the national table exists in the DOM, intialise the expandable rows
const checkForTable = function() {
  // alert("chewcking");
  /* waitForEl(".national-table tbody", function() {
    initialiseRows(ageGroups);
    initialiseRows(ethGroups);
  });*/
  setTimeout(function() {
    initialiseRows(ageGroups);
    initialiseRows(ethGroups);
  }, 500);
};



// Given an array of row names to initialise - i.e.: make sure they're collapsed to start with
const initialiseRows = function(data) {
  for(let i = 0; i < data.length; i++) {
    const el = data[i];
    const elements = document.querySelectorAll(".national-table tbody tr");
    
    for(let j = 0; j < elements.length; j++) {
      const element = elements[j];
      if(element.children[0].innerText === el){
        const row = element;
        console.log(row);
        row.children[0].classList.add("clickable-row-cell");
        row.children[0].classList.add("plus");
        const siblings = getChildRows(row);
        
        for(let k =0; k < siblings.length; k++) {
          const sb = siblings[k];
          if(sb.style.display !== "none"){
            sb.style.display = "none";
            sb.children[0].style.transform = "translateX(10px)";
          }
        }
      }
    }
  }
  console.log("Table rows initialised");
};






const extendLine = function (line) {
  if(line){
    if(line.attributes.d.value.indexOf("10000") === -1){
      const originalPath = line.getAttribute("d");
      const m = originalPath.substr(originalPath.indexOf("M")+1, originalPath.indexOf(",")-1);
      const l = originalPath.substr(originalPath.indexOf("L")+1, originalPath.indexOf(",")-2);
      let newPath = originalPath.replace(m, 0);
      newPath = newPath.replace(l, "10000");
    }
  }
}; 

navigator.sayswho= (function(){
    var ua= navigator.userAgent, tem, 
    M= ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) || [];
    if(/trident/i.test(M[1])){
        tem=  /\brv[ :]+(\d+)/g.exec(ua) || [];
        return 'IE '+(tem[1] || '');
    }
    if(M[1]=== 'Chrome'){
        tem= ua.match(/\b(OPR|Edge)\/(\d+)/);
        if(tem!= null) return tem.slice(1).join(' ').replace('OPR', 'Opera');
    }
    M= M[2]? [M[1], M[2]]: [navigator.appName, navigator.appVersion, '-?'];
    if((tem= ua.match(/version\/(\d+)/i))!= null) M.splice(1, 1, tem[1]);
    return M.join(' ');
})();

console.log(navigator.sayswho);


const printDocument = function() {
  const browser = navigator.sayswho;
  
  if(browser.indexOf("IE") > -1) {
    document.querySelector(".main-container").style.padding = 0;
  }
  window.print();
  if(browser.indexOf("IE") > -1) {
    document.querySelector(".main-container").style.padding = "1.6cm";
  }
};


const hidePrintModal = function() {
	const modal = document.querySelector(".print-view-modal");
	modal.style.right = "-500px";
	setTimeout(function(){
		modal.style.display = "none";
    }, 1000);
};





