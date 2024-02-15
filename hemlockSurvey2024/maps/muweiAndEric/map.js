/*
 * notes
 * 47.560852, -122.251770
 * 47.558488, -122.251819
 * 47.560852 - 47.558488 =  0.002364
 * at 0001 = 36'
 * 23.26 * 36  = 837 feet
 * 837 * pi: 2360 sq feet
 */
//let map;
let mapCenter = {lat: 47.55935, lng: -122.2529};
var locationMarker;
var map;

function readTreeData(){
  console.log("entering readTreeData")
  $.getJSON( "hemlocks.json", function(json) {
      window.trees = json
     })
   .done(function(){
      console.log("getJSON done")
      console.log("tree count: " + window.trees.length)
      map = initMap();
      })
   .fail(function(){
       console.log("getJSON failure")
       })
   }


await readTreeData()

$(document).ready(function(){
  readTreeData()
});



//--------------------------------------------------------------------------------
function printClickPoint(event){
   var lat = event.latLng["lat"]()
   var long = event.latLng["lng"]()
    console.log(lat.toFixed(6) + ", " + long.toFixed(6))
   }
//--------------------------------------------------------------------------------
function calculateHealthColor(tree){
    // R:  rev(colorRampPalette(c("green", "gray", "black"))(7))
    //var colors = ["#000000","#3F3F3F","#7E7E7E","#BEBEBE","#7ED37E","#3FE93F","#00FF00"]
    var colors = ["#000000","#5F5F5F","#BEBEBE","#A7D6A7","#90EE90","#48F648","#00FF00"]
    var healthScore = tree["h"]
    var breaks = [0.5,1.0,1.5,2.0,2.5,3.0,3.5]
    // R:round(seq(0,3,length.out=7), digits=2)
    for(let i=0; i < breaks.length; i++){
       if(healthScore < breaks[i]){
          return(colors[i])
          }
       } // for i
    } // calculateHealthColo

//--------------------------------------------------------------------------------
async function initMap(){

  const {Map} = await google.maps.importLibrary("maps");

  const defaultTreeMarker =  {path: google.maps.SymbolPath.CIRCLE,
                                 fillColor: '#FFF',
                                 fillOpacity: 0.6,
                                 strokeColor: '#000',
                                 strokeOpacity: 0.9,
                                 strokeWeight: 1,
                                 scale: 4
                                }

    const graveyardCoords = [{lat: 47.559355, lng:-122.252906},
                             {lat: 47.559082, lng: -122.252489},
                             {lat: 47.558857, lng: -122.252434},
                             {lat: 47.558693, lng: -122.251979},
                             {lat: 47.558528, lng: -122.251732},
                             //{lat: 47.558828, lng: -122.251432},
                             //{lat: 47.558720, lng: -122.251191},
                             {lat: 47.558697, lng: -122.250759},
                             //{lat: 47.559072, lng: -122.250957},
                             //{lat: 47.559203, lng: -122.250919},
                             {lat: 47.559298, lng: -122.250696}, // keep
                             //{lat: 47.559363, lng: -122.250932},
                             //{lat: 47.559217, lng: -122.251167},
                             //{lat: 47.559397, lng: -122.251226},
                             //{lat: 47.559567, lng: -122.251202},
                             //{lat: 47.559768, lng: -122.251344},
                             {lat: 47.559933, lng: -122.251126}, // keep
                             //{lat: 47.559997, lng: -122.251362},
                             //{lat: 47.560023, lng: -122.251469},
                             {lat: 47.560232, lng: -122.251311},
                             //{lat: 47.560383, lng: -122.251541},
                             //{lat: 47.560502, lng: -122.251669},
                             {lat: 47.560665, lng: -122.251542},
                             //{lat: 47.560653, lng: -122.251744},
                             {lat: 47.560668, lng: -122.252147},
                             //{lat: 47.560380, lng: -122.252204},
                             {lat: 47.560447, lng: -122.252476},
                             {lat: 47.560367, lng: -122.252554},
                             //{lat: 47.560105, lng: -122.252684},
                             {lat: 47.560125, lng: -122.252947},
                             //{lat: 47.559822, lng: -122.252949},
                             {lat: 47.559577, lng: -122.253091},
                             //{lat: 47.559407, lng: -122.252691},
                             //{lat: 47.559450, lng: -122.252822},
                             //{lat: 47.559405, lng: -122.252739},
                             {lat: 47.559355, lng: -122.252906}];


  const graveyard = new google.maps.Polygon({
    paths: graveyardCoords,
    strokeColor: "#FF0000",
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: "#FF0000",
    fillOpacity: 0.05,
    });

  map = new Map(document.getElementById("map"),
                {center: {lat: 47.55935, lng: -122.2529},
                 zoom: 16,
                });

   /*******
  graveyard.setMap(map);
  graveyard.addListener("click", (event) => {
     printClickPoint(event)
     })

   ******/

   /***************
  const bigCircleNorth = new google.maps.Circle({
      strokeColor: "#0000FF",
      strokeOpacity: 1.0,
      strokeWeight: 4,
      fillColor: "#FFFFFF",
      fillOpacity: 0.00,
      map,
      center: {lat: 47.559258, lng: -122.251877},
      //center: {lat: 47.559674, lng: -122.251877},
      radius: 160
      });

  const bigCircleSouth = new google.maps.Circle({
      strokeColor: "#0000FF",
      strokeOpacity: 1.0,
      strokeWeight: 4,
      fillColor: "#FFFFFF",
      fillOpacity: 0.00,
      map,
      center: {lat: 47.554286, lng: -122.249140},
      radius: 160
      });
      *********/

        
  map.addListener("click", (mapsMouseEvent) => {
     printClickPoint(mapsMouseEvent);
     })
                  
    drawTrees(map)
    return(map)

} // initMap function

//map.addListener('tilesloaded', function () { // ... })
//$(document).ready(function(){

async function drawTrees(map){
  //await readTreeData();
  console.log("tree count: " + window.trees.length)
  window.trees.forEach(function(tree){
      var size = tree["dbh"]/2;
      if(size < 5){
         size = 5;
         }
       const icon = {path: google.maps.SymbolPath.CIRCLE,
                     scale: size,
                     fillOpacity: 1,
                     strokeWeight: 1,
                     fillColor: calculateHealthColor(tree),
                     strokeColor: '#000',
                     }
       let marker = new google.maps.Marker({
           position: {lat:  tree["lat"], lng: tree["lon"]},
           map,
           title: tree["id"].toString(),
           icon: icon
           })
       //let label = {text: tree["id"].toString,
       //             color: "black",
       //             fontSize: "32px"}
       //marker.setLabel(label)
       let infoWindow = new google.maps.InfoWindow({
           content: "<h4> tree #" + tree["id"] + " (" + tree["observer"] + ")</h4>" +
             "<ul>" +
               "<li> dbh: " + tree["dbh"] +
               "<li> h1: " + tree["h1"] +
               "<li> h2: " + tree["h2"] +
               "<li> h3: " + tree["h3"] +
               "<li> overall health: " + tree["h"] +
               "<li> aspect: " + tree["aspect"] +
               "<li> slope: " + tree["slope"] + 
               "</ul>" +
               tree["comments"]
           })
       //marker.addListener("mouseover", () => {
       //  console.log(tree["id"])
       //  })
       marker.addListener("click", () => {
          infoWindow.open({
             anchor: marker,
             map,
             });
          })
       }) // forEach




  //google.maps.event.addListenerOnce(map, 'idle', function(){
     setInterval(function(){
        navigator.geolocation.getCurrentPosition(function(pos){
           var latLng = {"lat": pos.coords.latitude, "lng": pos.coords.longitude};
           if(typeof(locationMarker) == "undefined"){
              locationMarker = new google.maps.Marker({
                 position: mapCenter,
                 map: map,
                 icon: {
                    path: google.maps.SymbolPath.CIRCLE,
                    scale: 10,
                    fillOpacity: 1,
                    strokeWeight: 1,
                    fillColor: '#5384ED',
                    strokeColor: '#ffffff',
                    },
                 });
           locationMarker.setPosition(latLng)
           }
         })
      }, 1000);
} // drawTrees
