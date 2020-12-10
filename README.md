# How it works
Scroll to element navigation found in Cancer Care explorer

![alt text](https://github.com/epi-interactive/Cancer_care-navigation/blob/master/navigation%20cancer%20care.PNG?raw=true)
1. Create a vertical tabs input inside a sidebar page. The vertical tabs contain a list of names of all tabs.
![alt text](https://github.com/epi-interactive/Cancer_care-navigation/blob/master/vertical%20tab.PNG?raw=true)
2. The observe Event reactive function is used to handle the events on the side bar. If the tab is clicked a value based on the name of the tab that was clicked is stored in a variable.
![alt text](https://github.com/epi-interactive/Cancer_care-navigation/blob/master/server.PNG?raw=true)
3. The scroll to Element JavaScript function is also called every time a tab is clicked, and the name of the tab is passed in the parameter.
![alt text](https://github.com/epi-interactive/Cancer_care-navigation/blob/master/scroll.PNG?raw=true)
4. The scroll to Element function verifies if the browser used is Internet Explorer and if it is the case the animate method is used to scroll to the top of the element. Otherwise, the window. Scroll method is used.
![alt text](https://github.com/epi-interactive/Cancer_care-navigation/blob/master/render.PNG?raw=true)
5. Each section is rendered using render UI reactive function 
