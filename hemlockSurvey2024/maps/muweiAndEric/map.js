//let map;
let mapCenter = {lat: 47.55935, lng: -122.2529};
var locationMarker; // = new google.maps.Marker({position: mapCenter});


async function initMap(){

  const {Map} = await google.maps.importLibrary("maps");
  const defaultTreeMarker =  {path: google.maps.SymbolPath.CIRCLE,
                              fillColor: '#FFF',
                              fillOpacity: 0.6,
                              strokeColor: '#000',
                              strokeOpacity: 0.9,
                              strokeWeight: 1,
                              scale: 9
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


  new google.maps.Marker({
      position: {lat: 47.560123, lng: -122.252269}, map, title: "1",
      icon: icon_1
      });
  new google.maps.Marker({
      position: {lat: 47.560078, lng: -122.251997}, map, title: "2",
      icon: icon_2
      });
  new google.maps.Marker({
      position: {lat: 47.560222, lng: -122.251542}, map, title: "3",
      icon: icon_3
      })

   new google.maps.Marker({
      position: {lat:  47.560238, lng: -122.251492}, 
      map, title: '4',
      icon: defaultTreeMarker
      })
   new google.maps.Marker({
      position: {lat:  47.560243, lng: -122.251862}, 
      map, title: '5',
      icon: defaultTreeMarker
      })
   new google.maps.Marker({
      position: {lat:  47.560185, lng: -122.251651}, 
      map, title: '6',
      icon: defaultTreeMarker
      })
   new google.maps.Marker({
      position: {lat:  47.560467, lng: -122.252022}, 
      map, title: '7',
      icon: defaultTreeMarker
      })
   new google.maps.Marker({
      position: {lat:  47.560190, lng: -122.251801}, 
      map, title: '2001',
      icon: defaultTreeMarker
      })
   new google.maps.Marker({
      position: {lat:  47.560378, lng: -122.252334}, 
      map, title: '8',
      icon: defaultTreeMarker
      })
   new google.maps.Marker({
      position: {lat:  47.560123, lng: 122.251439}, 
      map, title: '2002',
      icon: defaultTreeMarker
      })
   new google.maps.Marker({
      position: {lat:  47.560077, lng: -122.251421}, 
      map, title: '2003',
      icon: defaultTreeMarker
      })
   new google.maps.Marker({
      position: {lat:  47.560608, lng: 122.252472}, 
      map, title: '9',
      icon: defaultTreeMarker
      })
   new google.maps.Marker({
      position: {lat:  47.560082, lng: -122.251506}, 
      map, title: '2004',
      icon: defaultTreeMarker
      })
   new google.maps.Marker({
      position: {lat:  47.559895, lng: -122.251352}, 
      map, title: '2005',
      icon: defaultTreeMarker
      })
   new google.maps.Marker({
      position: {lat:  47.559777, lng: -122.251322}, 
      map, title: '2006',
      icon: defaultTreeMarker
      })
   new google.maps.Marker({
      position: {lat:  47.559765, lng: -122.251321}, 
      map, title: '2007',
      icon: defaultTreeMarker
      })
   new google.maps.Marker({
      position: {lat:  47.559978, lng: -122.252067}, 
      map, title: '10',
      icon: defaultTreeMarker
      })
   new google.maps.Marker({
      position: {lat:  47.559593, lng: -122.251197}, 
      map, title: '2008',
      icon: defaultTreeMarker
      })
   new google.maps.Marker({
      position: {lat:  47.559647, lng: -122.251397}, 
      map, title: '2009',
      icon: defaultTreeMarker
      })
   new google.maps.Marker({
      position: {lat:  47.559773, lng: -122.252059}, 
      map, title: '11',
      icon: defaultTreeMarker
      })
   new google.maps.Marker({
      position: {lat:  47.559513, lng: -122.251344}, 
      map, title: '2010',
      icon: defaultTreeMarker
      })
   new google.maps.Marker({
      position: {lat:  47.559422, lng: -122.251409}, 
      map, title: '2011',
      icon: defaultTreeMarker
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
