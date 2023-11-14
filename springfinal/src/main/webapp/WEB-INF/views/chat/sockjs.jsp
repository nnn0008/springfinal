<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/leftSidebar.jsp"></jsp:include>


<!doctype html>
<html lang="ko">
<html xmlns:th="http://www.thymeleaf.org">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Bootstrap demo</title>

<!-- 아이콘 사용을 위한 Font Awesome 6 CDN -->
<link rel="stylesheet" type="text/css"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootswatch/5.3.2/zephyr/bootstrap.min.css"
	rel="stylesheet">
<link href="test.css" rel="stylesheet">

<link href="${pageContext.request.contextPath}/css/chat.css"
	rel="stylesheet">

<style>
</style>

</head>


<body>
	<div class="container-fluid">
		<div class="row">
			<div class="col">


				<!-- 메세지 헤더 -->
				<div class="row card-header msg_head">


					<div class="col">
						<div class="offcanvas offcanvas-end" tabindex="-1"
							id="offcanvasExample" aria-labelledby="offcanvasExampleLabel">
							<div class="offcanvas-header">
								<h5 class="offcanvas-title" id="offcanvasExampleLabel"></h5>
								<button type="button" class="btn-close text-reset"
									data-bs-dismiss="offcanvas" aria-label="Close"></button>
							</div>
							<div class="offcanvas-body">
								<div class="col-md-4 client-list"></div>
								<div class="col-md-4 chatRoom-list"></div>
								<div></div>
							</div>
						</div>
					</div>
				</div>

				<!-- 메세지 표시 영역 -->
				<div class="row">
					<div class="col message-list"></div>
				</div>

				<div class="row mt-4">
					<div class="col p-0">
						<div class="input-group">
						<input type="file" name="attach" multiple>
						<button class="send-file-btn">전송</button>

								<input type="text" class="form-control message-input"
									placeholder="메세지를 입력하세요">
								<button type="button" class="btn send-btn btn-success bg-miso">
									<i class="fa-regular fa-paper-plane"></i> 보내기
								</button>
							</div>

					</div>
				</div>

			</div>
		</div>


		<!-- 모달 -->
		<div class="modal fade" id="profileModal" tabindex="-1"
			aria-labelledby="profileModalLabel" aria-hidden="true"
			data-bs-backdrop="static">
			<div class="modal-dialog modal-dialog-centered">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="profileModalLabel">프로필</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="닫기"></button>
					</div>
					<div class="modal-body">
						<!-- 프로필 카드 내용 -->
						<div class="modal-card" style="border-radius: 15px;">
							<div class="modal-card-body text-center">
								<div class="mt-3 mb-4">
									<img
										src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-chat/ava2-bg.webp"
										class="rounded-circle img-fluid modal-profile-image"
										style="width: 100px;" />
								</div>
								<h4 class="mb-2 modal-profile-name">줄리 L. 아르소노</h4>
								<p class="text-muted mb-4 modal-profile-id"></p>
								<div class="mb-4 pb-2">
									<button type="button" class="btn btn-success bg-miso dm-send">메세지
										보내기</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>


	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
	<!-- 웹소켓 서버가 SockJS일 경우 페이지에서도 SockJS를 사용해야 한다 -->
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
	<script>
	
	//연결 생성
	//연결 후 해야할 일들을 콜백함수로 지정(onopen, onclose, onerror, onmessage)
	
	// 클라이언트에서 SockJS로 서버에 접속하는 부분

	var chatRoomNo = getRoomNoFromURL();  // 채팅방 번호를 얻어옴
	
	window.socket = new SockJS("${pageContext.request.contextPath}/ws/chat");
	
	var chatSender = "${sessionScope.name}"; //발신자
	var memberName = null;
	//console.log(memberName);
	
	var oneChatMemberName = null;
	
	var prevMessageDate = null;
	var clubName;

	window.socket.onopen = function (e) {
	     console.log('Info: connection opened.');
	    
// 	    console.log("chatRoomNo:", chatRoomNo); // 디버그용 로그 추가
// 	    console.log("chatSender:", chatSender); // 디버그용 로그 추가
	    	   
	    // 서버에 join 메시지 전송
	    var joinMessage = {
	        messageType: "join",
	        chatRoomNo: ${chatRoomNo},
	        chatSender: chatSender,
	        memberName: memberName
	    };

	    window.socket.send(JSON.stringify(joinMessage));
	  
	};

	// 방 이동 시
	function moveToRoom(selectedRoomNo) {
	    window.location.href = "/chat/enterRoom/" + selectedRoomNo;
	}

	// JavaScript에서 룸번호 읽어오기
	function getRoomNoFromURL() {
	    var url = window.location.href;
	    var match = url.match(/\/chat\/enterRoom\/(\d+)/);
	    return match ? parseInt(match[1]) : null;
	}	
	
	$(".send-file-btn").click(function(){
			var files = $("[name=attach]")[0].files;
			if(files.length === 0) return;
			
			for(let i=0; i < files.length; i++) {
				var reader = new FileReader();
				reader.onload = (e)=>{
					var data = e.target.result;
					var fileName = files[i].name; // 파일 이름 가져오기
					var fileSize = files[i].size; // 파일 크기 가져오기
					var fileType = files[i].type; // 파일 타입 가져오기
					var json = JSON.stringify({
						messageType : "file",
						chatSender: "${sessionScope.name}",
						chatRoomNo : ${chatRoomNo},
						chatContent : data,
						fileName: fileName, // 파일 이름 추가
						fileSize : fileSize,
						fileType : fileType, 
					});
					socket.send(json);
				};
				reader.readAsDataURL(files[i]);
			}
		});
	
	
	//메세지 처리
		window.socket.onmessage = function(e){
	
		
		var data = JSON.parse(e.data);
		console.log(data);
	
		clubName = data.clubName;
		//console.log(data.clubName);
		
		$(".circle-name").text(clubName);
		
		//메세지타입이 file이라면 수신처리
		if(data.messageType === "file"){
			console.log("file data: ", data); // 이 줄 추가
			$("<img>").attr("src", data.chatContent)
			.css("max-width", "200px")
			.appendTo(".message-list");
		}

		//메세지 타입이 디엠이라면 해당 룸번호로 이동
		if(data.messageType === "dm" && data.chatRoomNo){
			moveToRoom(data.chatRoomNo);
		}
		
		 // 만약 메세지 타입이 dm이면서 receiver가 있는 경우
	    if (data.messageType === "dm" && data.chatReceiver) {    	
	    	 console.log("Before moveToRoom: ", data); // 이 줄 추가
	    	 
	        // 방 이동 처리
	        moveToRoom(data.chatRoomNo);
	        
	        var chatContent = $(".message-input").val().trim(); // 값이 없을 경우 공백으로 처리

	        // 메시지 내용이 비어있으면 전송하지 않음
		    if (!chatContent) {
		        console.log("Content is empty. Message not sent.");
		        return;
		    }
	        
	        // 메세지 전송 처리
	        var sendMessage = {
	            messageType: "dm",
	            memberId: data.memberId,
	            chatRoomNo: data.chatRoomNo,
	            content: chatContent, 
	        };
	        
	        console.log("Before sending message: ", sendMessage); // 이 줄 추가

	        window.socket.send(JSON.stringify(sendMessage));
	    }
		 
		// 시간을 표시할 패턴 설정
		var dateOptions = {
		    year: "numeric",
		    month: "long",
		    day: "numeric",
		    weekday: "long",
		};

		var chatTimeAsString = data.chatTime; // JSON에서 문자열로 가져온 chatTime
		var chatTime = new Date(chatTimeAsString); // 문자열을 Date 객체로 변환

		// 날짜를 원하는 형식으로 포맷팅
		var formattedDate = chatTime.toLocaleDateString("ko-KR", dateOptions);

		// 시간을 원하는 형식으로 포맷팅
		var options = {
		    hour: "numeric",
		    minute: "numeric",
		    hour12: true // 오전/오후 표시를 사용
		};

		var formattedTime = chatTime.toLocaleTimeString("ko-KR", options);

		// 메시지를 구성할 때 날짜와 시간을 함께 사용
		var fullMessage = formattedDate + " " + formattedTime + " " + data.content;
	
	
		
		//사용자가 접속하거나 종료했을 때 서버에서 오는 데이터로 목록을 갱신
		//사용자가 메세지를 보냈을 때 서버에서 이를 전체에게 전달한다
		if (data.roomMembers) { // 목록 처리
	   	 $(".client-list").empty();
	
	    var ul = $("<ul>").addClass("list-group");
	    var loggedInUserId = "${sessionScope.name}";
	    var loggedInUserItem = null;
	
	    //console.log("chatRoomNo: " + chatRoomNo);
	
	    for (var i = 0; i < data.roomMembers.length; i++) {
	        var memberId = data.roomMembers[i].memberId;
	        var roomNo = data.roomMembers[i].chatRoomNo;
	        var memberLevel = data.roomMembers[i].memberLevel;
	        var memberName = data.roomMembers[i].memberName;
	        //console.log("memberName2: " + memberName);
	        
	        // 레벨에 따라 배지 스타일 변경
	        badgeClass = "bg-warning";
	        if (memberLevel === "관리자") {
	            badgeClass = "bg-danger";
	        } else if (memberLevel === "일반유저") {
	            var badgeClass = "bg-miso";
	        }
	
	        var listItem = $("<li>")
	            .addClass("list-group-item d-flex justify-content-between align-items-center")
	            .append(
	                $("<img>").addClass("rounded-circle user_img").attr("src", "${pageContext.request.contextPath}/images/member.png").css("width", "50px")
	            )
	            .append(
	                $("<span>").text(memberName)
	            )
	            .append(
	                $("<span>").addClass("badge rounded-pill").addClass(badgeClass)
	                    .text(memberLevel)
	            );
	
	        if (memberId === loggedInUserId) {
	            // 본인의 아이디를 찾았을 때 별도로 저장
	            loggedInUserItem = listItem;
	            listItem.append($("<span>").addClass("badge rounded-pill bg-warning").text("나"));
	        } else {
	            // "나" 라벨을 추가하지 않고 공백을 추가하여 크기를 맞춤
	            listItem.append($("<span>").addClass("badge rounded-pil bg-null").text(" "));
	            ul.append(listItem);
	        }
	    }

    if (loggedInUserItem) {
        // 본인의 아이디를 목록의 맨 위에 추가
        ul.prepend(loggedInUserItem);
    }

    // 목록이 client-list에 표시됩니다.
    ul.appendTo(".client-list");
}

		
		else if (data.content) { // 메세지 처리 
			
			
		
		    var memberId = "${sessionScope.name}";
		   // console.log(memberId);
		    var chatSender = data.memberId;
		   // console.log("sender",chatSender)
		    
		    var memberName = data.memberName;
		    var oneChatMemberName = data.oneChatMemberName;
			console.log("oneChatMemberName",oneChatMemberName);
		   
		   // console.log(memberName);
		    
		 // 새로운 메시지의 날짜 정보 가져오기
		    var chatTimeAsString = data.chatTime; // JSON에서 문자열로 가져온 chatTime
		    var chatTime = new Date(chatTimeAsString); // 문자열을 Date 객체로 변환
		    var messageDate = chatTime.toDateString(); // 날짜 정보만 추출

		 // 날짜가 변경된 경우에만 표시
		    if (messageDate !== prevMessageDate) {
		        // 날짜 표시 부분 스타일 추가
		        var dateDiv = $("<div>")
		            .addClass("date-divider")
		            .text(formattedDate)
				             .css({
		            'font-weight': 'bold',
		            'margin-top': '10px',
		            'margin-bottom': '10px',
		            'text-align': 'center',
		        });
		        $(".message-list").append(dateDiv);
		        prevMessageDate = messageDate; // 이전 날짜 갱신
		    }
		            
		    var content = $("<div>").text(data.content);
		    var memberLevel = $("<span>").text(data.memberLevel).addClass("badge rounded-pill ms-2");

		    // 메세지 레벨에 따라 배지 스타일 변경
		    if (data.memberLevel == "일반") {
		        memberLevel.addClass("bg-gray");
		    } else if (data.memberLevel == "관리자") {
		        memberLevel.addClass("bg-danger");
		    } else if (data.memberLevel == "VIP") {
		        memberLevel.addClass("bg-warning");
		    }
		   
		                   
		    if (memberId === chatSender) {         
		    	
		        // 본인 메시지 (오른쪽에 표시)
		        var messageDiv = $("<div>").addClass("d-flex justify-content-end mb-4 mt-2");

		        var messageContainer = $("<div>").addClass("msg_cotainer_send")
		            .append(content);
		           
		        var imageContainer = $("<div>").addClass("img_cont_msg")
		            .append($("<img>").attr("src", "${pageContext.request.contextPath}/images/profile.jpg").css("width", "45px").addClass("rounded-circle user_img_msg"));

		        var timeSpan = $("<div>").addClass("time-right")
		         .append($("<span>").addClass("msg_time_send").text(formattedTime));
		        
		        messageDiv.append(timeSpan).append(messageContainer).append(imageContainer);
		        $(".message-list").append(messageDiv);
		        

		    } else {
		    	
		    	// 상대방 메시지 (왼쪽에 표시)
		    	var messageDiv = $("<div>").addClass("d-flex mb-4 align-items-start mt-2");

		    	var imageContainer = $("<div>").addClass("img_cont_msg")
		    	    .append($("<img>").attr("src", "${pageContext.request.contextPath}/images/profile2.jpg").css("width", "45px").addClass("rounded-circle user_img_msg"));

		    	// 클릭 이벤트 추가
		    	imageContainer.on("click", function() {
		    	    $.ajax({
		    	        url: 'http://localhost:8080/getProfile',
		    	        type: 'GET',
		    	        dataType: 'json',
		    	        success: function(data) {
		    	            // 성공적으로 데이터를 받아왔을 때 처리
		    	            console.log(data); // 여기서 data는 List<MemberDto> 형태

		    	            // data 배열에서 클릭된 멤버의 정보 찾기
		    	            var selectedMember = data.find(function(member) {
		    	                // nicknameDiv에서 텍스트 정보 가져오기
		    	                var nicknameText = $(".msg_nickname", messageDiv).text();
		    	                return nicknameText === member.memberName;
		    	            });

		    	            // selectedMember가 존재할 때만 모달을 업데이트
		    	            if (selectedMember) {
		    	                // 모달 내용 업데이트
		    	                $("#profileModalLabel").text(selectedMember.memberName+" 님의 프로필"); // 모달 제목 업데이트
		    	                var modalBody = $("#profileModal .modal-body");
		    	                modalBody.find(".modal-profile-image").attr("src", "${pageContext.request.contextPath}/images/profile2.jpg"); // 이미지 업데이트
		    	                modalBody.find(".modal-profile-name").text(selectedMember.memberName); // 이름 업데이트
		    	                modalBody.find(".modal-profile-id").text("@" + selectedMember.memberId); // 아이디 업데이트

		    	                // 모달 표시
		    	                $("#profileModal").modal("show");
		    	            }
		    	        },
		    	        error: function(error) {
		    	            // 오류 발생 시 처리
		    	            console.error(error);
		    	        }
		    	    });
		    	});
		    	
				   console.log(data.memberId); 
				   console.log(data.memberName);
				
		    	var contentDiv = $("<div>").addClass("d-flex flex-column");
		    	
		    	var nicknameDiv = $("<div>").addClass("msg_nickname")
		        .text(data.memberId === data.memberName ? oneChatMemberName : memberName);
		    	
		    	var messageContainer = $("<div>").addClass("msg_cotainer")
		    	    .append(content);

		    	var timeSpan = $("<div>").addClass("time-left")
		    	    .append($("<span>").addClass("msg_time").text(formattedTime));

		    	contentDiv.append(nicknameDiv).append(messageContainer);
		    	messageDiv.append(imageContainer).append(contentDiv).append(timeSpan);
		    	$(".message-list").append(messageDiv);

		    	
		    }
		}
		

		// 스크롤바 이동
		$(".message-list").scrollTop($(".message-list")[0].scrollHeight);
	}
	
		//메세지를 전송하는 코드
		//-메세지가 @로 시작하면 DM으로 처리(아이디 유무 검사정도 하면 좋음)
		//- @아이디 메세지		
		//엔터키로 메세지 전송
		$(".message-input").keydown(function (e) {
	    if (e.keyCode === 13) { // Enter 키 눌림
	        sendMessage();
	    }
			});
		
		$(".send-btn").click(function () {
		    sendMessage();
		});
		
	 
		// dm 요청 함수
		$(".dm-send").on("click", function () {
		    // 모달에서 상대방 정보 가져오기
		    var chatReceiver = $("#profileModal .modal-profile-id").text().trim();

		    // "@" 이후의 문자열 추출
		    var atSymbolIndex = chatReceiver.indexOf("@");
		    var relativeUserId = atSymbolIndex !== -1 ? chatReceiver.slice(atSymbolIndex + 1) : null;

		    // 채팅 메시지 객체 생성
		    var dm = {
		        messageType: "dm",
		        chatSender: "${sessionScope.name}", // 사용자 이름 또는 아이디 등
		        chatReceiver: relativeUserId, // "@" 이후의 문자열을 상대방 아이디로 사용
		    };

		    // WebSocket을 통해 서버로 메시지 전송
		    window.socket.send(JSON.stringify(dm));

		    console.log("DM 메시지 전송 완료");
		    console.log(dm);
		});

		
		// 메시지 전송 함수
		function sendMessage() {
		    var chatContent = $(".message-input").val().trim(); // 값이 없을 경우 공백으로 처리
		    var messageType = "message";
		    var sessionName = "${sessionScope.name}";
		    var chatRoomNo = ${chatRoomNo};
		    
		    // 메시지 내용이 비어있으면 전송하지 않음
		    if (!chatContent) {
		        console.log("Content is empty. Message not sent.");
		        return;
		    }

		    var message = {
		        messageType: messageType,
		        chatSender: sessionName,
		        chatContent: chatContent,
		        chatRoomNo: chatRoomNo
		    };

		    // 서버로 메시지 전송
		    window.socket.send(JSON.stringify(message));

		    // 메시지 입력창 초기화
		    $(".message-input").val("");
		}
		

		// 메시지 전송 이벤트 처리
		function handleSendMessage() {
		    var inputElement = document.querySelector(".message-input");
		    var messageContent = inputElement.value;

		    // 메시지가 비어있지 않은 경우에만 전송
		    if (messageContent.trim() !== "") {
		        sendMessage(messageContent);

		        // 전송 후 입력창 비우기
		        inputElement.value = "";
		    }
		}

		// 이벤트 리스너 등록
		document.querySelector(".send-btn").addEventListener("click", handleSendMessage);


		// 메세지 헤더 생성
		var headerContent = $("<div>").addClass("d-flex bd-highlight justify-content-between");
		var imageContainer = $("<div>").addClass("img_cont");
		var userImage = $("<img>").attr("src", "/images/circle.jpg").css("width", "60px").addClass("rounded-circle user_img");
		var userInfo = $("<div>").addClass("user_info");
		var roomName = $("<span>").addClass("circle-name").text(clubName);

		// 버튼 엘리먼트 생성
		var button = $("<button>").addClass("btn btn-outline-secondary");
		button.attr("type", "button");
		button.attr("data-bs-toggle", "offcanvas");
		button.attr("data-bs-target", "#offcanvasExample");
		button.attr("aria-controls", "offcanvasExample");
		var buttonIcon = $("<i>").addClass("fa-solid fa-users");
		button.append(buttonIcon);

		userInfo.append(roomName);
		imageContainer.append(userImage);
		headerContent.append(imageContainer).append(userInfo).append(button); 
		var headerElement = $("<div>").addClass("card-header msg_head").append(headerContent);

		// .card-header 요소에 메세지 헤더 추가
		$(".card-header").append(headerElement);


		//.btn-userlist를 누르면 사용자 목록에 active를 붙였다 떼었다 하도록 처리
		$(".btn-userlist").click(function(){
			$(".client-list").toggleClass("active");
		});
		

	</script>
</body>
</html>

<jsp:include page="/WEB-INF/views/template/rightSidebar.jsp"></jsp:include>