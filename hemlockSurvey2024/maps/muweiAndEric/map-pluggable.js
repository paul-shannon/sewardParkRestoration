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
      console.log("getJSON trees done")
      console.log("tree count: " + window.trees.length)
      map = initMap();
      })
   .fail(function(){
       console.log("getJSON failure")
       })

  $.getJSON( "gardenBoundaries.json", function(json) {
      window.gardenBoundaries = json
      })
   .done(function(){
      console.log("getJSON on garden boundaries complete")
      console.log("gardenBoundar count: " + window.gardenBoundaries.length)
      })
   .fail(function(){
       console.log("getJSON failure")
       })

  $.getJSON( "graveyardBoundaries.json", function(json) {
      window.graveyardBoundaries = json
      })
   .done(function(){
      console.log("getJSON on graveyard boundaries complete")
      console.log("graveyard boundar count: " + window.graveyardBoundaries.length)
      })
   .fail(function(){
       console.log("getJSON failure")
       })


   } // readTreeData


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
    var colors = ["#000000","#5F5F5F","#BEBEBE","#A7D6A7","#90EE90","#48F648","#00FF00","#00FF00"]
    var healthScore = tree["h"]
    var breaks = [0.5,1.0,1.5,2.0,2.5,3.0,3.5,5.0]
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

    const graveyardCoordsCalculated = [
{lat:  47.55938843, lng: -122.25286543},
{lat:  47.55939978, lng: -122.25286620},
{lat:  47.55942886, lng: -122.25286716},
{lat:  47.55945794, lng: -122.25286715},
{lat:  47.55948702, lng: -122.25286616},
{lat:  47.55949786, lng: -122.25286543},
{lat:  47.55951610, lng: -122.25286419},
{lat:  47.55954518, lng: -122.25286123},
{lat:  47.55957426, lng: -122.25285730},
{lat:  47.55960334, lng: -122.25285238},
{lat:  47.55962549, lng: -122.25284789},
{lat:  47.55963242, lng: -122.25284645},
{lat:  47.55966150, lng: -122.25283943},
{lat:  47.55969058, lng: -122.25283137},
{lat:  47.55969388, lng: -122.25283035},
{lat:  47.55971966, lng: -122.25282211},
{lat:  47.55974583, lng: -122.25281281},
{lat:  47.55974874, lng: -122.25281174},
{lat:  47.55977782, lng: -122.25280003},
{lat:  47.55978871, lng: -122.25279526},
{lat:  47.55980690, lng: -122.25278701},
{lat:  47.55982584, lng: -122.25277772},
{lat:  47.55983598, lng: -122.25277256},
{lat:  47.55985869, lng: -122.25276018},
{lat:  47.55986506, lng: -122.25275656},
{lat:  47.55988814, lng: -122.25274263},
{lat:  47.55989414, lng: -122.25273886},
{lat:  47.55991486, lng: -122.25272509},
{lat:  47.55992322, lng: -122.25271929},
{lat:  47.55993934, lng: -122.25270755},
{lat:  47.55995230, lng: -122.25269768},
{lat:  47.55996196, lng: -122.25269000},
{lat:  47.55998138, lng: -122.25267385},
{lat:  47.55998299, lng: -122.25267246},
{lat:  47.56000246, lng: -122.25265492},
{lat:  47.56001046, lng: -122.25264738},
{lat:  47.56002074, lng: -122.25263737},
{lat:  47.56003797, lng: -122.25261983},
{lat:  47.56003955, lng: -122.25261817},
{lat:  47.56005411, lng: -122.25260229},
{lat:  47.56006863, lng: -122.25258575},
{lat:  47.56006948, lng: -122.25258475},
{lat:  47.56008396, lng: -122.25256720},
{lat:  47.56009771, lng: -122.25254984},
{lat:  47.56009785, lng: -122.25254966},
{lat:  47.56011101, lng: -122.25253212},
{lat:  47.56012368, lng: -122.25251457},
{lat:  47.56012679, lng: -122.25251014},
{lat:  47.56013582, lng: -122.25249703},
{lat:  47.56014754, lng: -122.25247949},
{lat:  47.56015587, lng: -122.25246665},
{lat:  47.56015888, lng: -122.25246194},
{lat:  47.56016985, lng: -122.25244440},
{lat:  47.56018056, lng: -122.25242686},
{lat:  47.56018495, lng: -122.25241953},
{lat:  47.56019100, lng: -122.25240931},
{lat:  47.56020121, lng: -122.25239177},
{lat:  47.56021127, lng: -122.25237423},
{lat:  47.56021403, lng: -122.25236935},
{lat:  47.56022114, lng: -122.25235669},
{lat:  47.56023090, lng: -122.25233914},
{lat:  47.56024056, lng: -122.25232160},
{lat:  47.56024311, lng: -122.25231695},
{lat:  47.56025013, lng: -122.25230406},
{lat:  47.56025962, lng: -122.25228651},
{lat:  47.56026908, lng: -122.25226897},
{lat:  47.56027219, lng: -122.25226319},
{lat:  47.56027849, lng: -122.25225143},
{lat:  47.56028785, lng: -122.25223388},
{lat:  47.56029719, lng: -122.25221634},
{lat:  47.56030127, lng: -122.25220868},
{lat:  47.56030650, lng: -122.25219880},
{lat:  47.56031577, lng: -122.25218125},
{lat:  47.56032500, lng: -122.25216371},
{lat:  47.56033035, lng: -122.25215349},
{lat:  47.56033418, lng: -122.25214617},
{lat:  47.56034329, lng: -122.25212863},
{lat:  47.56035233, lng: -122.25211108},
{lat:  47.56035943, lng: -122.25209717},
{lat:  47.56036128, lng: -122.25209354},
{lat:  47.56037011, lng: -122.25207600},
{lat:  47.56037881, lng: -122.25205845},
{lat:  47.56038736, lng: -122.25204091},
{lat:  47.56038851, lng: -122.25203850},
{lat:  47.56039572, lng: -122.25202337},
{lat:  47.56040388, lng: -122.25200582},
{lat:  47.56041180, lng: -122.25198828},
{lat:  47.56041759, lng: -122.25197504},
{lat:  47.56041947, lng: -122.25197074},
{lat:  47.56042684, lng: -122.25195319},
{lat:  47.56043389, lng: -122.25193565},
{lat:  47.56044058, lng: -122.25191811},
{lat:  47.56044667, lng: -122.25190118},
{lat:  47.56044689, lng: -122.25190057},
{lat:  47.56045278, lng: -122.25188302},
{lat:  47.56045823, lng: -122.25186548},
{lat:  47.56046319, lng: -122.25184794},
{lat:  47.56046763, lng: -122.25183039},
{lat:  47.56047152, lng: -122.25181285},
{lat:  47.56047482, lng: -122.25179531},
{lat:  47.56047575, lng: -122.25178924},
{lat:  47.56047751, lng: -122.25177776},
{lat:  47.56047954, lng: -122.25176022},
{lat:  47.56048087, lng: -122.25174268},
{lat:  47.56048148, lng: -122.25172513},
{lat:  47.56048132, lng: -122.25170759},
{lat:  47.56048034, lng: -122.25169005},
{lat:  47.56047853, lng: -122.25167251},
{lat:  47.56047582, lng: -122.25165496},
{lat:  47.56047575, lng: -122.25165461},
{lat:  47.56047217, lng: -122.25163742},
{lat:  47.56046753, lng: -122.25161988},
{lat:  47.56046186, lng: -122.25160233},
{lat:  47.56045512, lng: -122.25158479},
{lat:  47.56044724, lng: -122.25156725},
{lat:  47.56044667, lng: -122.25156612},
{lat:  47.56043812, lng: -122.25154970},
{lat:  47.56042774, lng: -122.25153216},
{lat:  47.56041759, lng: -122.25151688},
{lat:  47.56041605, lng: -122.25151462},
{lat:  47.56040286, lng: -122.25149707},
{lat:  47.56038851, lng: -122.25147986},
{lat:  47.56038823, lng: -122.25147953},
{lat:  47.56037187, lng: -122.25146199},
{lat:  47.56035943, lng: -122.25144975},
{lat:  47.56035383, lng: -122.25144444},
{lat:  47.56033391, lng: -122.25142690},
{lat:  47.56033035, lng: -122.25142397},
{lat:  47.56031189, lng: -122.25140936},
{lat:  47.56030127, lng: -122.25140148},
{lat:  47.56028766, lng: -122.25139182},
{lat:  47.56027219, lng: -122.25138144},
{lat:  47.56026097, lng: -122.25137427},
{lat:  47.56024311, lng: -122.25136341},
{lat:  47.56023154, lng: -122.25135673},
{lat:  47.56021403, lng: -122.25134705},
{lat:  47.56019900, lng: -122.25133919},
{lat:  47.56018495, lng: -122.25133210},
{lat:  47.56016295, lng: -122.25132164},
{lat:  47.56015587, lng: -122.25131838},
{lat:  47.56012679, lng: -122.25130576},
{lat:  47.56012273, lng: -122.25130410},
{lat:  47.56009771, lng: -122.25129413},
{lat:  47.56007736, lng: -122.25128656},
{lat:  47.56006863, lng: -122.25128337},
{lat:  47.56003955, lng: -122.25127343},
{lat:  47.56002564, lng: -122.25126901},
{lat:  47.56001046, lng: -122.25126425},
{lat:  47.55998138, lng: -122.25125578},
{lat:  47.55996534, lng: -122.25125147},
{lat:  47.55995230, lng: -122.25124798},
{lat:  47.55992322, lng: -122.25124083},
{lat:  47.55989414, lng: -122.25123431},
{lat:  47.55989225, lng: -122.25123393},
{lat:  47.55986506, lng: -122.25122837},
{lat:  47.55983598, lng: -122.25122304},
{lat:  47.55980690, lng: -122.25121830},
{lat:  47.55979342, lng: -122.25121638},
{lat:  47.55977782, lng: -122.25121413},
{lat:  47.55974874, lng: -122.25121054},
{lat:  47.55971966, lng: -122.25120754},
{lat:  47.55969058, lng: -122.25120515},
{lat:  47.55966150, lng: -122.25120337},
{lat:  47.55963242, lng: -122.25120222},
{lat:  47.55960334, lng: -122.25120172},
{lat:  47.55957426, lng: -122.25120188},
{lat:  47.55954518, lng: -122.25120274},
{lat:  47.55951610, lng: -122.25120432},
{lat:  47.55948702, lng: -122.25120667},
{lat:  47.55945794, lng: -122.25120983},
{lat:  47.55942886, lng: -122.25121385},
{lat:  47.55941375, lng: -122.25121638},
{lat:  47.55939978, lng: -122.25121874},
{lat:  47.55937070, lng: -122.25122453},
{lat:  47.55934162, lng: -122.25123136},
{lat:  47.55933206, lng: -122.25123393},
{lat:  47.55931254, lng: -122.25123920},
{lat:  47.55928346, lng: -122.25124817},
{lat:  47.55927389, lng: -122.25125147},
{lat:  47.55925438, lng: -122.25125828},
{lat:  47.55922700, lng: -122.25126901},
{lat:  47.55922530, lng: -122.25126969},
{lat:  47.55919622, lng: -122.25128236},
{lat:  47.55918745, lng: -122.25128656},
{lat:  47.55916714, lng: -122.25129646},
{lat:  47.55915277, lng: -122.25130410},
{lat:  47.55913806, lng: -122.25131210},
{lat:  47.55912180, lng: -122.25132164},
{lat:  47.55910898, lng: -122.25132938},
{lat:  47.55909380, lng: -122.25133919},
{lat:  47.55907990, lng: -122.25134845},
{lat:  47.55906822, lng: -122.25135673},
{lat:  47.55905082, lng: -122.25136951},
{lat:  47.55904469, lng: -122.25137427},
{lat:  47.55902293, lng: -122.25139182},
{lat:  47.55902174, lng: -122.25139281},
{lat:  47.55900282, lng: -122.25140936},
{lat:  47.55899266, lng: -122.25141867},
{lat:  47.55898405, lng: -122.25142690},
{lat:  47.55896655, lng: -122.25144444},
{lat:  47.55896358, lng: -122.25144755},
{lat:  47.55895025, lng: -122.25146199},
{lat:  47.55893499, lng: -122.25147953},
{lat:  47.55893450, lng: -122.25148012},
{lat:  47.55892078, lng: -122.25149707},
{lat:  47.55890748, lng: -122.25151462},
{lat:  47.55890542, lng: -122.25151748},
{lat:  47.55889510, lng: -122.25153216},
{lat:  47.55888357, lng: -122.25154970},
{lat:  47.55887634, lng: -122.25156144},
{lat:  47.55887283, lng: -122.25156725},
{lat:  47.55886288, lng: -122.25158479},
{lat:  47.55885367, lng: -122.25160233},
{lat:  47.55884726, lng: -122.25161552},
{lat:  47.55884517, lng: -122.25161988},
{lat:  47.55883735, lng: -122.25163742},
{lat:  47.55883020, lng: -122.25165496},
{lat:  47.55882368, lng: -122.25167251},
{lat:  47.55881818, lng: -122.25168884},
{lat:  47.55881778, lng: -122.25169005},
{lat:  47.55881244, lng: -122.25170759},
{lat:  47.55880768, lng: -122.25172513},
{lat:  47.55880346, lng: -122.25174268},
{lat:  47.55879977, lng: -122.25176022},
{lat:  47.55879657, lng: -122.25177776},
{lat:  47.55879385, lng: -122.25179531},
{lat:  47.55879158, lng: -122.25181285},
{lat:  47.55878975, lng: -122.25183039},
{lat:  47.55878910, lng: -122.25183830},
{lat:  47.55878831, lng: -122.25184794},
{lat:  47.55878726, lng: -122.25186548},
{lat:  47.55878656, lng: -122.25188302},
{lat:  47.55878620, lng: -122.25190057},
{lat:  47.55878616, lng: -122.25191811},
{lat:  47.55878640, lng: -122.25193565},
{lat:  47.55878691, lng: -122.25195319},
{lat:  47.55878766, lng: -122.25197074},
{lat:  47.55878863, lng: -122.25198828},
{lat:  47.55878910, lng: -122.25199541},
{lat:  47.55878978, lng: -122.25200582},
{lat:  47.55879111, lng: -122.25202337},
{lat:  47.55879259, lng: -122.25204091},
{lat:  47.55879420, lng: -122.25205845},
{lat:  47.55879592, lng: -122.25207600},
{lat:  47.55879774, lng: -122.25209354},
{lat:  47.55879962, lng: -122.25211108},
{lat:  47.55880158, lng: -122.25212863},
{lat:  47.55880358, lng: -122.25214617},
{lat:  47.55880562, lng: -122.25216371},
{lat:  47.55880770, lng: -122.25218125},
{lat:  47.55880981, lng: -122.25219880},
{lat:  47.55881195, lng: -122.25221634},
{lat:  47.55881412, lng: -122.25223388},
{lat:  47.55881632, lng: -122.25225143},
{lat:  47.55881818, lng: -122.25226591},
{lat:  47.55881857, lng: -122.25226897},
{lat:  47.55882089, lng: -122.25228651},
{lat:  47.55882329, lng: -122.25230406},
{lat:  47.55882578, lng: -122.25232160},
{lat:  47.55882838, lng: -122.25233914},
{lat:  47.55883112, lng: -122.25235669},
{lat:  47.55883403, lng: -122.25237423},
{lat:  47.55883714, lng: -122.25239177},
{lat:  47.55884049, lng: -122.25240931},
{lat:  47.55884411, lng: -122.25242686},
{lat:  47.55884726, lng: -122.25244092},
{lat:  47.55884805, lng: -122.25244440},
{lat:  47.55885239, lng: -122.25246194},
{lat:  47.55885714, lng: -122.25247949},
{lat:  47.55886235, lng: -122.25249703},
{lat:  47.55886806, lng: -122.25251457},
{lat:  47.55887434, lng: -122.25253212},
{lat:  47.55887634, lng: -122.25253724},
{lat:  47.55888132, lng: -122.25254966},
{lat:  47.55888903, lng: -122.25256720},
{lat:  47.55889751, lng: -122.25258475},
{lat:  47.55890542, lng: -122.25259970},
{lat:  47.55890684, lng: -122.25260229},
{lat:  47.55891726, lng: -122.25261983},
{lat:  47.55892869, lng: -122.25263737},
{lat:  47.55893450, lng: -122.25264559},
{lat:  47.55894138, lng: -122.25265492},
{lat:  47.55895543, lng: -122.25267246},
{lat:  47.55896358, lng: -122.25268184},
{lat:  47.55897102, lng: -122.25269000},
{lat:  47.55898834, lng: -122.25270755},
{lat:  47.55899266, lng: -122.25271162},
{lat:  47.55900779, lng: -122.25272509},
{lat:  47.55902174, lng: -122.25273662},
{lat:  47.55902950, lng: -122.25274263},
{lat:  47.55905082, lng: -122.25275804},
{lat:  47.55905400, lng: -122.25276018},
{lat:  47.55907990, lng: -122.25277649},
{lat:  47.55908203, lng: -122.25277772},
{lat:  47.55910898, lng: -122.25279246},
{lat:  47.55911461, lng: -122.25279526},
{lat:  47.55913806, lng: -122.25280634},
{lat:  47.55915327, lng: -122.25281281},
{lat:  47.55916714, lng: -122.25281842},
{lat:  47.55919622, lng: -122.25282891},
{lat:  47.55920072, lng: -122.25283035},
{lat:  47.55922530, lng: -122.25283786},
{lat:  47.55925438, lng: -122.25284552},
{lat:  47.55926496, lng: -122.25284789},
{lat:  47.55928346, lng: -122.25285189},
{lat:  47.55931254, lng: -122.25285708},
{lat:  47.55934162, lng: -122.25286118},
{lat:  47.55937070, lng: -122.25286421},
{lat:  47.55938843, lng: -122.25286543}]



    const graveyard = new google.maps.Polygon({
        paths:  window.graveyardBoundaries,
        strokeColor: "black",
        strokeOpacity: 0.8,
        strokeWeight: 5,
        fillColor: "#FF0000",
        fillOpacity: 0.05,
        });




    const garden = new google.maps.Polygon({
        paths: window.gardenBoundaries,
        strokeColor: "green",
        strokeOpacity: 0.8,
        strokeWeight: 5,
        fillColor: "#FF0000",
        fillOpacity: 0.05,
        });

  map = new Map(document.getElementById("map"),
                {center: {lat: 47.55935, lng: -122.2529},
                 zoom: 16.5,
                });

   /*******/
    console.log("setting graveyard")
  graveyard.setMap(map);
  graveyard.addListener("click", (event) => {
     printClickPoint(event)
     })
  garden.setMap(map);
  garden.addListener("click", (event) => {
     printClickPoint(event)
     })

   /******/

   /***************
  //bigCircleNorthCenter = {lat: 47.559258, lng: -122.251877}
  var bigCircleNorthCenter = {lat: 47.559757, lng: -122.252027}; 

  const bigCircleNorth = new google.maps.Circle({
      strokeColor: "#0000FF",
      strokeOpacity: 1.0,
      strokeWeight: 4,
      fillColor: "#FFFFFF",
      fillOpacity: 0.00,
      map,
      center: bigCircleNorthCenter,
      //center: {lat: 47.559674, lng: -122.251877},
      radius: 100
      }); ********/

  //bigCircleSouthCenter = {lat:  47.554286, lng: -122.249140}
  //var bigCircleSouthCenter = {lat:  47.554988, lng: -122.249278}

   /*******
  const bigCircleSouth = new google.maps.Circle({
      strokeColor: "#0000FF",
      strokeOpacity: 1.0,
      strokeWeight: 4,
      fillColor: "#FFFFFF",
      fillOpacity: 0.00,
      map,
      center: bigCircleSouthCenter,
      radius: 100
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
       let infoWindow = new google.maps.InfoWindow({
           content: "<h4> tree #" + tree["id"] + " (" + tree["observer"] + ")</h4>" +
             "<ul>" +
               "<li> dbh: " + tree["dbh"] +
               "<li> h1: " + tree["h1"] +
               "<li> h2: " + tree["h2"] +
               "<li> h3: " + tree["h3"] +
               "<li> lat: " + tree["lat"] +
               "<li> lon: " + tree["lon"] +
               "<li> overall health: " + tree["h"] +
               "<li> aspect: " + tree["aspect"] +
               "<li> slope: " + tree["slope"] + 
               "<li> date: " + tree["date"] + 
               "<li> location: " + tree["loc"] + 
               "</ul>" +
               tree["comments"]
           })
       marker.addListener("click", () => {
          infoWindow.open({
             anchor: marker,
             map,
             });
          })
       }) // forEach


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
