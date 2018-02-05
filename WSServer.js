var WebSocketServer = require('ws').Server,

	wss = new WebSocketServer({
		port: 6969
	});
wss.on('connection', function(ws) {
	console.log('client connected');



	//ws.send('You are' + wss.clients.length);


	//收到消息回调
	ws.on('message', function(message) {
		console.log(message);

		ws.send(message);



	});

	// 退出聊天  
	ws.on('close', function(close) {

		console.log('退出连接了');
	});
});

console.log('开始监听6969端口');