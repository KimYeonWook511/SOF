//console.log(addr);
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = {
        center: new kakao.maps.LatLng(36.417318549741985, 127.991151605902), // 지도의 중심좌표
        level: 13 // 지도의 확대 레벨
    };  

// 지도를 생성합니다    
var map = new kakao.maps.Map(mapContainer, mapOption); 

// 주소-좌표 변환 객체를 생성합니다
var geocoder = new kakao.maps.services.Geocoder();

function searchMapMarker(addrList) {
	for (let i = 0; i < addrList.length; i++)
	{
		let addr = addrList[i];
		
		geocoder.addressSearch(addr, function(result, status) {
		
		    // 정상적으로 검색이 완료됐으면 
		     if (status === kakao.maps.services.Status.OK) {
				
		        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
				
		        // 결과값으로 받은 위치를 마커로 표시합니다
		        new kakao.maps.Marker({
		            map: map,
		            position: coords,
		        });			
		    } 
		});
	}	
}