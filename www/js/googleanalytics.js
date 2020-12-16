// Google Analytics code for tracking app usage 
// Epi-interactive
// MoH Bowel Cancer Explorer 2019
//
// The code for tracking behviour on the app via Google Analytics is handled by listening for clicks and updates on 
// particular elements such as select inputs, checkboxes, radio buttons, regular buttons, and links. 
//
// In summary, there are three parts to this procedure: 
//    1. Listen for updates to select inputs (filter changes).
//    2. Listen for radio button updates (also filter changes).
//    3. And Listen for general clicks on the site.
//
// By listening for clicks, a string representing the target of the click is generated every time a click takes place.
// This string will include defining traits such as id's, classes, other attributes link href and data-*,
// as well as the text on the target. This string helps us find out the location of the click (which page and tab) 
// and the target for the click so we can determine the event we should track.
//
// Click track events include:
//  - Page changes            - Checkbox updates          - Opening the overview
//  - Tab changes             - Downloads                 - Links
//  - Print view

// Initial Analytics code to initialse tracking.
window.dataLayer = window.dataLayer || [];
function gtag() { dataLayer.push(arguments); }
gtag('js', new Date());
gtag('config', 'UA-3573389-49', {
            'page_title': "Home",
            'page_location': "LOCATION",
            'page_path': "/home"
});
        

// Step 1 - listen for filter changes.
// -----------------------------------------------------------------------------------------------------------------
$(document).on('change', 'select', function (e) {
    handleFilterChange(e);
});
// -----------------------------------------------------------------------------------------------------------------

// Step 2 - listen for radio button changes.
// -----------------------------------------------------------------------------------------------------------------
$(document).on('change', 'input[type=radio]', function(e) {
    handleRadioChange(e);
});

// (Not really a step) note path for the entry point when someone uses the app.
// -----------------------------------------------------------------------------------------------------------------
$(document).ready(function() {
  handleLanding();
});

// Step 3 - Listen for clicks for the rest of the behviour.
// -----------------------------------------------------------------------------------------------------------------
$(document).on('click', '', function (e) {
    // Initialise click and pages data
    const text = getClickInformation(e)[0];
    const combinedMsg = getClickInformation(e)[1];
    const pageList = getAppPages()[0];
    const pagePaths = getAppPages()[1];
    // Page changes
    if(pageList.indexOf(text) > -1) {
      handleClickedPageChange(text, pageList, pagePaths);
    } else if (
      // Checkbox changes
      combinedMsg.indexOf("-showLabels") > -1 || 
      combinedMsg.indexOf("-tableShow") > -1 ||
      combinedMsg.indexOf("-showNZ") > -1 ||
      combinedMsg.indexOf("-natTableShow") > -1) {
        handleCheckboxChange(combinedMsg, e);
    } else if (
      // Overview opening events
      combinedMsg.indexOf("indOverviewShowindicatoroverview") > -1 ||
      combinedMsg.indexOf("regOverviewShowindicatoroverview") > -1 ) {
        handleOverviewOpenings(combinedMsg);
    } else if (combinedMsg.indexOf("#tab-") > -1) {
      // Tab changes
      handleTabChange(combinedMsg);
    } else if (combinedMsg.indexOf("-DL") > -1) {
      // Download events
      handleDownloads(combinedMsg);
    } else if (combinedMsg.indexOf("downloadDataSets-downloadDataSetsData") > -1) {
      // Download datasets events
      handleDatasets(combinedMsg);
    } else if (combinedMsg.indexOf("startPrintViewYes") > -1) {
      // Print view events
      handlePrintView(combinedMsg);
    } else if ($(e.target).closest("a")[0]) {
      // Events on other links like Splash cards and Home images
      handleOtherLinkClick(e);
    }
});
// -----------------------------------------------------------------------------------------------------------------
// Handle filter changes
// - Called whenever the user selects a new option from a dropdown
// - Reports the new value selected from the dropdown
// -----------------------------------------------------------------------------------------------------------------
const handleFilterChange = function(event) {
    // Get the ID of the changed input
    var id = $(event.target).attr("id");
    // Error handling - remove the router prefix from input ID if required
    var router_prefix = "_router_ui";
    if (id.indexOf(router_prefix) > -1) {
      id = id.substring(router_prefix.length, id.length-1);
    }
    // Error handling - Get the closest element to the given ID
    if (typeof id == 'undefined') {
        id = $(event.target).closest('[id]').attr("id");
    }
    // Use Indicator short.descriptions instead of the indicator.id which is the default value
    let label = $(event.currentTarget).val();
    const element = $(event.target)[0];
    if(id.indexOf("-indicator") > -1) {
      for(let i = 0; i < element.options.length; i ++){
	        if(element.options[i].value == element.value){
    	      label = element.options[i].text;
      	}
      }
    }
    const eventName = id.substr(0, id.indexOf("-")) + "-filter" + id.substr(id.indexOf("-"));
    // Report change event back to Google
    gtag('event', eventName, {
      'event_category': 'filter',
      'event_label': label
    });
};
// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
// Handle radio input changes
// - Called whenever a radio button is clicked
// - Reports which radio button was clicked
// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
const handleRadioChange = function (event) {
    // Get the relvant attributes for naming the eventName
    const pageName = event.target.name;
    const eventName = pageName.substr(0, pageName.indexOf("-")) + "-filter"+ pageName.substr(pageName.indexOf("-"));
    const label = event.target.value;
    // Report change event back to Google
    gtag('event', eventName, {
      'event_category': 'filter',
      'event_label': label
    });
};
// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
// Handle landing
// - Called when the app is launched
// - Reports which page the user accessed on launch
// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
const handleLanding = function () {
  const startIndex = window.location.href.lastIndexOf("/");
  const path = window.location.href.substr(startIndex);
  const name = path.substr(1).substr(0, 1).toUpperCase() + path.substr(2);
  
  gtag('config', 'UA-3573389-49', {
      'page_title': name,
      'page_location': "LOCATION",
      'page_path': path
  });
};
// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
// Get click information
// - Called when a click is detected on the page
// - Determines what element the user was most likely trying to click on,
//   and returns a string representation of that element. 
// - Handling of the actual click is handled by other functions based on this data.
// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
const getClickInformation = function (event) {
  // Get the information from the click
    let text = $(event.target).text();
    let alt = $(event.target).attr("alt");
    let id = $(event.target).attr("id");
    let href = $(event.target).attr("href");
    let combinedMsg = "";

    // Get the current ID or the closest ID
    if (typeof id != 'undefined') {
        combinedMsg += id;
    } else if (typeof id == 'undefined') {
        id = $(event.target).closest('[id]').attr("id");
        combinedMsg += id;
    }
    // Get the text of a clickable object or alt of an img 
    if (typeof text != 'undefined' && text.length > 0) {
        text = text.replace(/\s+/g, '');
        combinedMsg += text;
    } else if (typeof alt != 'undefined') {
        alt = alt.replace(/\s+/g, '');
        text = alt;
        combinedMsg += text;
    } else {
        text = "";
    }
    // Replace spaces with no space
    if (typeof href != 'undefined') {
        href = href.replace(/\s+/g, '');
        combinedMsg += href;
    } else {
        href = "";
    }
    return [text, combinedMsg];
};

// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
// Handle Clicked Page Change
// - Called whenever the user clicks to change the page.
// - Reports which page the user clicked on.
// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
const handleClickedPageChange = function (text, titles, paths) {
  const pageTitle = titles[titles.indexOf(text)];
  const pagePath = paths[titles.indexOf(text)]; 
  gtag('config', 'UA-3573389-49', {
        'page_title': pageTitle,
        'page_location': "LOCATION",
        'page_path': "/" + pagePath
  });
};

// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
// Get App Pages
// - Returns the pages availble in the app.
// - Change these for a new app or if the routes change.
// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
const getAppPages = function () {
      // Determine which page the user has clicked to go to
    const pageList = [
      "Overview", "Exploreindicators", "Myregion", "Methodology",
      "Downloaddatasets", "Home", "About", "Help" 
    ];
    const pagePaths = [
      "overview", "explore-indicators", "my-region",
      "methodology", "download-datasets", "home", "about", "help"
    ];
    return [ pageList, pagePaths ];
};

// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
// Handle checkbox changes
// - Run when a checkbox is checked or unchecked.
// - Reports the value that has been toggled and the current status of it (yes or no).
// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
const handleCheckboxChange = function (message, event) {
      const currentPage = message.substring(0, message.indexOf("-"));
      let [ currentTab, table ] = getCheckboxDetails(message);
      // Get the name of the checkbox that was clicked
      let checkClicked = event.target.value;
      // Handle unnamed checkboxes
      if(checkClicked === "on") {
        const id = event.target.id;
        checkClicked = id.substr(id.indexOf("-") + 1);
      }
      // Determine if it was clicked off or on
      const checkStatus = event.target.checked ? "Yes" : "No";
      // Format strings for report
      const eventId = currentPage + "-" + currentTab.toLowerCase() + "-" + "checkbox" + "_show-" + checkClicked + (table ? "-" + table : "");
      const eventCategory = "checkbox";
      const eventLabel = checkStatus;
      // Report click change back to Google
      if(checkClicked !== undefined){
        gtag('event', eventId, {
          'event_category': eventCategory,
          'event_label': eventLabel
        });
      }
};

// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
// Get checkbox details 
// - Helper function for handleCheckboxChange()
// - Returns the current active tab by looking for the name of a checkbox unique to each tab
// - Also returns the table the check is associated with in the case of Explore Indicators > Tables
//   where there are two filters with the same name (show signicant values only).
// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
const getCheckboxDetails = function (message) {
    let currentTab = "";
    let table = "";
    if(message.indexOf("-showLabels") > -1) {
      currentTab = "Summary";
    } else if(message.indexOf("-tableShow") > -1 ){
      currentTab = "Tables";
      table = "regional";
    } else if(message.indexOf("-natTableShow") > -1) {
      currentTab = "Tables";
      table = "national";
    } else if(message.indexOf("-showNZ") > -1) {
      currentTab = "Summary";
    }
    return [ currentTab, table ];
};

// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
// Handle overview openings
// - Run every time the user clicks either one of the Indicator Overviews
// - Reports which Indicator Overview was clicked
// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
const handleOverviewOpenings = function(message) {
     if(message.indexOf("indOverviewShowindicatoroverview") > -1 ){
       eventId = "exploreIndicators-button-indicator-overview";
       label = "Show topic overview";
     } else {
       eventId = "myRegion-button-indicator-overview";
       label = "Show indicator overview";
     }
     // If the ID for the overview is in the click event, report the event back to Google
     gtag('event', eventId, {
        'event_category': "button",
        'event_label': label
      });
};

// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
// Handle tab change
// - Run whenever the user changes tab. Vertical tabs from Overview/Methodology are excluded.
// - Reports which tab was selected.
// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
const handleTabChange = function (message) {
  // If the click event string has a tab name in it, note which tab was clicked 
     let currentPage;
     if(message.indexOf("exploreIndicators-") > -1) {
       currentPage = "exploreIndicators";
     } else {
       currentPage = "myRegion";
     }
     const currenttab = message.substring(message.indexOf("-tabset") + 7, message.indexOf("#"));
     const eventId = currentPage + "-" + "tab" + "-" + currenttab.toLowerCase();
     // Report tab change back to Google
     gtag('event', eventId, {
        'event_category': "tab"
      });
};

// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
// Handle downloads
// - Run whenever a non-DownloadDatasets download is initiated.
// - Reports the name and type of the download.
// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
const handleDownloads = function (message) {
     // If the click event string has the -DL suffix, then it is for a DL event
     const currentPage = message.substr(0, message.indexOf("-"));
     // const [ currentTab, downloadType ] = getDownloadDetails(message);
     const currentTab = getDownloadDetails(message)[0];
     const downloadType = getDownloadDetails(message)[1];
     
     const eventId = currentPage + "-" + currentTab + "-download-" + downloadType;
     // Report back to Google
     gtag('event', eventId, {
        'event_category': "download"
      });
};

// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
// Get download details
// - Helper function for Handle Downloads
// - Determines the tab and type of the download by looking for a substring unique to that tab and download pair.
// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
const getDownloadDetails = function (message) {
  let currentTab = "";
  let downloadType = "";
  // Explore Indicators downloads
   if(message.indexOf("DLSummaryHTML") > -1) {
     currentTab = "summary";
   } else if (message.indexOf("DLTablesCSV") > -1) {
     currentTab = "tables";
   // My Region downloads   
   } else if(message.indexOf("DLSummaryHTMLChart") > -1) {
     currentTab = "summary";
   } else if (message.indexOf("DLTablesCSVData") > -1) {
     currentTab = "tables";
   } 
   // Based on which string in is the click event string, determine what kind of download it is
   if(message.indexOf("html") > -1) {
     downloadType = "html";
   }
   else if(message.indexOf("csv") > -1) {
     downloadType = "csv";
   }
   return [ currentTab, downloadType ];
};

// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
// Handle datasets
// - Run whenever a DownloadDatasets download is clicked.
// - Report which download file was selected.
// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
const handleDatasets = function (message) {
  let downloadType = "";
   if(message.indexOf("2013-2016") > -1) {
     downloadType = "2013-2016";
   } else if(message.indexOf("2013-2014") > -1) {
     downloadType = "2013-2014";
   } else if(message.indexOf("2015-2016") > -1) {
     downloadType = "2015-2016";
   }
   const eventId = "downloadDatasets-download-" + downloadType;
   gtag('event', eventId, {
      'event_category': "download"
    });
};

// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
// Handle print view
// - Run whenever one of the "Go to print view" links is clicked
// - More specifically, it's run when "Yes" is selected in the proceding lightbox.
// - Reports which print view was selected (Indicator or Regional).
// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
const handlePrintView = function (message) {
    let currentPage;
    let suffix;
    if(message.indexOf("exploreIndicators") > -1) {
      currentPage = "exploreIndicators";
      suffix = "indicator";
    } else {
      currentPage = "myRegion";
      suffix = "regional";
    }
    const eventId = currentPage + "-print-" + suffix;
    gtag('event', eventId, {
       'event_category': "print"
    });
};

// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
// Handle other link click
// - Run whenever any other significant <a> tag (i.e.: not an external link) is clicked 
//    that doesn't fall into any of the above functions.
// - Mainly used for tracking Splash links and going home from the corner header logo.
// - Reports the new path.
// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
const handleOtherLinkClick = function (event) {
    const link = $(event.target).closest("a")[0];
    if(link) {
    const path = link.pathname;
    gtag('config', 'UA-3573389-49', {
          'page_title': path.substr(1),
          'page_location': "LOCATION",
          'page_path': path
    });
    } 
};

// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
// CW


