//let map;
let mapCenter = {lat: 47.55935, lng: -122.2529};
var locationMarker;


async function initMap(){

  const {Map} = await google.maps.importLibrary("maps");
  const defaultTreeMarker =  {path: google.maps.SymbolPath.CIRCLE,
                              fillColor: '#FFF',
                              fillOpacity: 0.6,
                              strokeColor: '#000',
                              strokeOpacity: 0.9,
                              strokeWeight: 1,
                              scale: 4
                              };

  const icon_1 = {path: google.maps.SymbolPath.CIRCLE,
                  fillColor: '#000',
                  fillOpacity: 0.6,
                  strokeColor: '#00A',
                  strokeOpacity: 0.9,
                  strokeWeight: 1,
                  scale: 9
                  }
  const icon_2 = {path: google.maps.SymbolPath.CIRCLE,
                  fillColor: '#3E3',
                  fillOpacity: 0.6,
                  strokeColor: '#00A',
                  strokeOpacity: 0.9,
                  strokeWeight: 1,
                  scale: 6
                  }
  const icon_3 = {path: google.maps.SymbolPath.CIRCLE,
                  fillColor: '#333',
                  fillOpacity: 0.6,
                  strokeColor: '#00A',
                  strokeOpacity: 0.9,
                  strokeWeight: 1,
                  scale: 7
                  }

    const graveyardCoords = [{lat: 47.559355, lng:-122.252906},
                             {lat: 47.559082, lng: -122.252489},
                             {lat: 47.558857, lng: -122.252434},
                             {lat: 47.558693, lng: -122.251979},
                             {lat: 47.558528, lng: -122.251732},
                             {lat: 47.558828, lng: -122.251432},
                             {lat: 47.558720, lng: -122.251191},
                             {lat: 47.558697, lng: -122.250759},
                             {lat: 47.559072, lng: -122.250957},
                             {lat: 47.559203, lng: -122.250919},
                             {lat: 47.559298, lng: -122.250696},
                             {lat: 47.559363, lng: -122.250932},
                             {lat: 47.559217, lng: -122.251167},
                             {lat: 47.559397, lng: -122.251226},
                             {lat: 47.559567, lng: -122.251202},
                             {lat: 47.559768, lng: -122.251344},
                             {lat: 47.559933, lng: -122.251126},
                             {lat: 47.559997, lng: -122.251362},
                             {lat: 47.560023, lng: -122.251469},
                             {lat: 47.560232, lng: -122.251311},
                             {lat: 47.560383, lng: -122.251541},
                             {lat: 47.560502, lng: -122.251669},
                             {lat: 47.560665, lng: -122.251542},
                             {lat: 47.560653, lng: -122.251744},
                             {lat: 47.560668, lng: -122.252147},
                             {lat: 47.560380, lng: -122.252204},
                             {lat: 47.560447, lng: -122.252476},
                             {lat: 47.560367, lng: -122.252554},
                             {lat: 47.560105, lng: -122.252684},
                             {lat: 47.560125, lng: -122.252947},
                             {lat: 47.559822, lng: -122.252949},
                             {lat: 47.559577, lng: -122.253091},
                             {lat: 47.559407, lng: -122.252691},
                             {lat: 47.559450, lng: -122.252822},
                             {lat: 47.559405, lng: -122.252739},
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

  graveyard.setMap(map);

  var marker;
  var infoWindow;

   marker = new google.maps.Marker({
      position: {lat:  47.560123, lng: -122.252269}, 
      map, title: '1',
      icon: defaultTreeMarker
      })
   infoWindow = new google.maps.InfoWindow({
       content: '1'
       })

    marker.addListener("click", () => {
       infoWindow.open({
          anchor: marker,
          map,
         });
       });


   marker = new google.maps.Marker({
      position: {lat:  47.560078, lng: -122.251997}, 
      map, title: '2',
      icon: defaultTreeMarker
      })
   infoWindow = new google.maps.InfoWindow({
   content: '2'
    })
   marker = new google.maps.Marker({
      position: {lat:  47.560222, lng: -122.251542}, 
      map, title: '3',
      icon: defaultTreeMarker
      })
   infoWindow = new google.maps.InfoWindow({
   content: '3'
    })
   marker = new google.maps.Marker({
      position: {lat:  47.560238, lng: -122.251492}, 
      map, title: '4',
      icon: defaultTreeMarker
      })
   infoWindow = new google.maps.InfoWindow({
   content: '4'
    })
   marker = new google.maps.Marker({
      position: {lat:  47.560243, lng: -122.251862}, 
      map, title: '5',
      icon: defaultTreeMarker
      })
   infoWindow = new google.maps.InfoWindow({
   content: '5'
    })

    return(map)
} // initMap function

var map = initMap();

$(document).ready(function(){
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
                    strokeWeight: 2,
                    fillColor: '#5384ED',
                    strokeColor: '#ffffff',
                    },
                 });
           locationMarker.setPosition(latLng)
           }
         })
      }, 1000);
    //})
}) // document.ready
