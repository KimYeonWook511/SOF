let addr = "주소";
let coords, marker, infowindow;

var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = {
        center: new kakao.maps.LatLng(36.417318549741985, 127.991151605902), // 지도의 중심좌표
        level: 13 // 지도의 확대 레벨
    };  

// 지도를 생성합니다    
var map = new kakao.maps.Map(mapContainer, mapOption); 

// 주소-좌표 변환 객체를 생성합니다
var geocoder = new kakao.maps.services.Geocoder();

$('#searchBtn').click(function() {
	addr = document.querySelector('#searchMap').value;
	
	updateSideMap(addr);
});

function updateSideMap(addr) {
	geocoder.addressSearch(addr, function(result, status) {

	    // 정상적으로 검색이 완료됐으면 
	    if (status === kakao.maps.services.Status.OK) {
		
			if (marker !== undefined)
			{
				marker.setMap(null);			
			}
			
			if (marker2 != undefined)
			{
				marker2.setMap(null);
				infowindow2.close();
			}
			
	        coords = new kakao.maps.LatLng(result[0].y, result[0].x);
			
	        // 결과값으로 받은 위치를 마커로 표시합니다
	        marker = new kakao.maps.Marker({
	            map: map,
	            position: coords,
	        });
	
	        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
			map.setLevel(3);
	        map.setCenter(coords);
    	} 
	});  
}

// 현재 지도 중심좌표로 주소를 검색해서 지도 좌측 상단에 표시합니다
searchAddrFromCoords(map.getCenter());

var marker2 = new kakao.maps.Marker(), // 클릭한 위치를 표시할 마커입니다
    					infowindow2 = new kakao.maps.InfoWindow({zindex:1}); // 클릭한 위치에 대한 주소를 표시할 인포윈도우입니다

// 지도를 클릭했을 때 클릭 위치 좌표에 대한 주소정보를 표시하도록 이벤트를 등록합니다
kakao.maps.event.addListener(map, 'click', function(mouseEvent) {	
    searchDetailAddrFromCoords(mouseEvent.latLng, function(result, status) {
        if (status === kakao.maps.services.Status.OK) {
			if (marker !== undefined)
			{
				marker.setMap(null);			
			}
			
			var detailAddr = !!result[0].road_address ? '<div style="width: auto; height: auto;">도로명주소 : ' + result[0].road_address.address_name + '</div>' : '';
            detailAddr += '<div style="width: auto; height: auto;">지번 주소 : ' + result[0].address.address_name + '</div>';
            
            var content = '<div style="width: auto; height: auto; max-height: 60px; min-height: 30px; min-width: 300px;">' + detailAddr + '</div>';

            // 마커를 클릭한 위치에 표시합니다 
            marker2.setPosition(mouseEvent.latLng);
            marker2.setMap(map);

            // 인포윈도우에 클릭한 위치에 대한 법정동 상세 주소정보를 표시합니다
            infowindow2.setContent(content);
            infowindow2.open(map, marker2);
        }   
    });
});

// 중심 좌표나 확대 수준이 변경됐을 때 지도 중심 좌표에 대한 주소 정보를 표시하도록 이벤트를 등록합니다
kakao.maps.event.addListener(map, function() {
    searchAddrFromCoords(map.getCenter());
});

function searchAddrFromCoords(coords, callback) {
    // 좌표로 행정동 주소 정보를 요청합니다
    geocoder.coord2RegionCode(coords.getLng(), coords.getLat(), callback);         
}

function searchDetailAddrFromCoords(coords, callback) {
    // 좌표로 법정동 상세 주소 정보를 요청합니다
    geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
}