/*$(document.body).on("click", "[nav-to]",
function (e) {
  Shiny.onInputChange("navigateTo", $(e.currentTarget).attr("nav-to"));
});*/

// URL input binding
// This input binding is very similar to textInputBinding from
// shiny.js.
var navInputBinding = new Shiny.InputBinding();

// An input binding must implement these methods
$.extend(navInputBinding, {

  // This returns a jQuery object with the DOM element
  find: function(scope) {
    return $(scope).find('[nav-container]');
  },
  // return the ID of the DOM element
  getId: function(el) {
    return el.id;
  },
  // Given the DOM element for the input, return the value
  getValue: function(el) {
    var sel =  $(el).data("selected");
    return sel;
  },
  // Given the DOM element for the input, set the value
  setValue: function(el, value) {},
  // Set up the event listeners so that interactions with the
  // input will result in data being sent to server.
  // callback is a function that queues data to be sent to
  // the server.
  subscribe: function(el, callback) {
    $(el).on('click.navInputBinding', function(event) {
      $(el).data("selected", $(event.target).closest("[nav-to]").attr("nav-to"));
      callback(false);
      // When called with true, it will use the rate policy,
      // which in this case is to debounce at 500ms.
    });
  },
  // Remove the event listeners
  unsubscribe: function(el) {
    $(el).off('.navInputBinding');
  },

  // Receive messages from the server.
  // Messages sent by updateNavInput() are received by this function.
/*  receiveMessage: function(el, data) {
    if (data.hasOwnProperty('value'))
      this.setValue(el, data.value);

    if (data.hasOwnProperty('label'))
      $(el).parent().find('label[for="' + $escape(el.id) + '"]').text(data.label);

    $(el).trigger('change');
  },*/

  // This returns a full description of the input's state.
  // Note that some inputs may be too complex for a full description of the
  // state to be feasible.
  getState: function(el) {
    /*return {
      label: $(el).parent().find('label[for="' + $escape(el.id) + '"]').text(),
      value: el.value
    };*/
  },

  // The input rate limiting policy
  getRatePolicy: function() {
    return {
      // Can be 'debounce' or 'throttle'
      policy: 'debounce',
      delay: 500
    };
  }
});

Shiny.inputBindings.register(navInputBinding, 'shiny.navInput');

$(document.body).on("click", ".filter-title",
function (e) {
  Shiny.onInputChange($(e.currentTarget).closest('.filter-group').attr('id'), $(e.currentTarget).text());
});

Shiny.addCustomMessageHandler("sendInput", function(e){
  console.log(e);
  Shiny.onInputChange(e.id, e.val);
});

$(document.body).on("click", "[click-spin]",
function (e) {
  $(e.currentTarget).find('i.fa').addClass('fa-spin')
  .closest('button').prop('disabled', true);
});

Shiny.addCustomMessageHandler("clearSpinner",
  function(id) {
	  $('#'+id).find('.fa').removeClass('fa-spin')
	  .closest('button').prop('disabled', false);
  }
);


//Only checking that you are putting in a number
$(document.body).on('keydown', "input[type='number']", function(e) {
  var inp = $(e.currentTarget);
  
  //store intial state once only!
  if(!inp.data("oldval")){
    inp.data("oldval", inp.val());
  }
  if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
             // Allow: Ctrl+A, Command+A
            (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) || 
             // Allow: home, end, left, right, down, up
            (e.keyCode >= 35 && e.keyCode <= 40)) {
                 // let it happen, don't do anything
                 return;
        }
        // Ensure that it is a number and stop the keypress
        if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
            e.preventDefault();
        }
});

//check aftermath of input
$(document.body).on('input', "input[type='number']", function(e){
  var inp = $(e.currentTarget);
  if(inp.data("oldval") === inp.val()){
    e.preventDefault();
    return;
  }
  
  var max = inp.attr('max');
  var min = inp.attr('min');
  if(max && (parseFloat(inp.val()) > parseFloat(max))){
    e.preventDefault();
    inp.val(inp.data("oldval"));
    return;
  }
  if(min && (parseFloat(inp.val()) < parseFloat(min))){
    e.preventDefault();
    inp.val(inp.data("oldval"));
    return;
  }
  //new value is valid, update the 'oldval'
  inp.data("oldval", inp.val());
});

var footer;
$(
  footer = $('#footer')
)

Shiny.addCustomMessageHandler("unfade-page", function(e) {
  console.log('fading');
    $(".load-fade").addClass("out");
})
//GL

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
  if(indModal) {
    listenForModalClose(indModal);
  } 
  if(regModal){
    listenForModalClose(regModal);
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
/*const ageGroups = ["18-49 years", "50-59 years", "60-74 years", "75 years and over"];*/
const ethGroups = ["Māori", "Pacific", "Asian", "European/Other"];


// If theres click on a row containing a group mentioned above, expand/collapse the following rows accordingly
$(document.body).on("click", function(e) {
  const table = document.querySelector(".national-table");
  if(table){
    const target = e.target;
    if(target.localName === "td"){
      const parent = target.parentNode;
      if(ethGroups.find(function(el){ return el === target.innerText })){
       changeRows(parent); 
      }
    }
  }
});


const getChildRows = function (row, siblingCount) {
  
  const text = row.children[0].innerText;
  const siblings = [];
  for(let i = 0; i < siblingCount+1; i++) {
      if(i==0){
          siblings.push(row.nextSibling)
      }else{
           siblings.push(siblings[i-1].nextSibling)
      }
  }
  const reduced = siblings.filter(function(el) {
    return el.children[0].innerText.indexOf(text) > -1;
  });
  return reduced;
};


// Expand/collapse "child" rows 
const changeRows = function(row) {
  // Get the "child" rows
  const siblings = document.querySelectorAll(".".concat(row.children[0].innerText));
  
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
    /*initialiseRows(ageGroups);*/
    const table = document.querySelectorAll(".national-table");
    if(table.length > 0 ){
        initialiseRows(ethGroups);
    }
  }, 1500);
};



// Given an array of row names to initialise - i.e.: make sure they're collapsed to start with
const initialiseRows = function(data) {
  for(let i = 0; i < data.length; i++) {
    const el = data[i];
    var nextel = "Neighbourhood deprivation"
    if(i+1 < data.length){
         nextel = data[i+1];
         
    }
    const elements = document.querySelectorAll(".national-table tbody tr");

    var nextelindex = 0;
    
    for(let j = 0; j < elements.length; j++) {
        if(elements[j].children[0].innerText === nextel){
          nextelindex = j;
      }
    }
   
    for(let j = 0; j < elements.length; j++) {
      const element = elements[j];
      
      if(element.children[0].innerText === el){
        const row = element;
        row.children[0].classList.add("clickable-row-cell");
        row.children[0].classList.add("plus");
        const siblings = getChildRows(row, nextelindex - j);
        for(let k =0; k < siblings.length; k++) {
          const sb = siblings[k];
          sb.classList.add(el);
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


/*const formatOverviewBtn = function(target) {
  const el = document.querySelector(target);
  if(el.style.position === ""||el.style.position === "sticky") {
    const header = document.querySelector(".header").offsetHeight;
    const nav = document.querySelector(".navbar-moh").offsetHeight;
    if(window.scrollY === 0){
      el.style.top = (0) + "px";
    } else {
      el.style.top = (window.scrollY - header - nav) + "px";
    }
  }
  el.style.position = "relative";
};*/

const moveModalBackdrop = function(type) {
  let backdrop;
  if(type === "indicator"){
    backdrop = document.querySelector("#modal-exploreIndicators-indOverview");
  } else {
    backdrop = document.querySelector("#modal-myRegion-regionOverview");
  }
  
  const ui = document.querySelector("#_router_ui");
  ui.append(backdrop);
  
};


const listenForModalClose = function(modal) {
  var observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutationRecord) {
        const sidebar = document.querySelector(".flex-sidebar .sticky");
        if(mutationRecord.target.style.display === "none" && sidebar.style.top !== 0){
            sidebar.style.top = 0;
            if(sidebar.style.position == "relative"){
              sidebar.style.position = "sticky";
            }
        }
    });    
  });
  
  
  observer.observe(modal, { attributes : true, attributeFilter : ['style'] });
}; 


const extendLine = function (line) {
  if(line){
    if(line.attributes.d.value.indexOf("10000") === -1){
      const originalPath = line.getAttribute("d");
      const m = originalPath.substr(originalPath.indexOf("M")+1, originalPath.indexOf(",")-1);
      const l = originalPath.substr(originalPath.indexOf("L")+1, originalPath.indexOf(",")-2);
      let newPath = originalPath.replace(m, 0);
      newPath = newPath.replace(l, "10000");
      /*line.attributes.d.value = newPath;
      const flag = document.createAttribute("mutated");
      flag.value = "yes";
      line.setAttributeNode(flag);*/
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




const scrollToElement = function(element) {
  console.log(element);
  if(navigator.sayswho.indexOf("IE") > -1) {
    $("html, body").animate({
        scrollTop: element.offsetTop
    }, 1500);

  } else {
    window.scroll({ 
      top: element.offsetTop,
      left: element.offsetLeft,
      behavior: 'smooth'
    });
  }
};


var closeButtons = document.querySelectorAll("#close");

for(var i = 0; i < closeButtons.length; i++) {
  var el = closeButtons[i];
  el.addEventListener("click", function () {
	  const indModal = $("#indicatorsPrintPromptLink");
	  if($("#indicatorsPrintPromptLink").css("display") !== "none") {
	    $("#indicatorsPrintPromptLink").modal("toggle")
	  } else {
	    $("#regionalPrintPromptLink").modal("toggle")
	  }
  });
}


const setPageTitle = function (title) {
  document.title = title + " | Cancer Care Data Explorer";
};


const scrollToTop = function() {
    window.scrollTo(0,0);
}

const toggleVerticalTabDropdown = function(id, isDropdown) {
    Shiny.setInputValue('activeSection', id);
    // Hide all other drop-downs and show the clicked drop-down
    
    elems = $('.vertical-tab-binding').children('.vt-dropdown');
    elems.children('.vt-dropdown-content').hide();
    if(isDropdown) {
        searchstring = "#" + id + ' + .vt-dropdown-content'
        elems.find(searchstring).show();
    }
    
    scrollToTop();
}


const setHeatmapSort = function(cg, value) {
    
    currentValue = Shiny.shinyapp.$inputValues[cg + "-indicatorSummary-heatmapSort"];
    console.log(currentValue);
    if(currentValue == null || currentValue != value) {
        Shiny.setInputValue(cg + "-indicatorSummary-heatmapSortReverse", false);
    }
    else {
        currentReverse = Shiny.shinyapp.$inputValues[cg + "-indicatorSummary-heatmapSortReverse"];
        Shiny.setInputValue(cg + "-indicatorSummary-heatmapSortReverse", !currentReverse);
    }
    
    Shiny.setInputValue(cg + "-indicatorSummary-heatmapSort", value);
}



