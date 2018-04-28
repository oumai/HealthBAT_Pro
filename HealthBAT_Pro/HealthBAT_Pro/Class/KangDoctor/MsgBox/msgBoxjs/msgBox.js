//用户头像
var userIcon = "http://upload.jkbat.com/20160922/uylxcxky.flj.png";
//康博士头像
var drKangIcon = "http://upload.jkbat.com/Files/20170525/izsbpi13.mea.png";

var msgBox = {
    init: function () {
        var _this = this;
        _this.bindEvent();
/*        mui.init({
            pullRefresh: {
                container: '#pullrefresh',
                down: {
                    callback: _this.pulldownRefresh
                }
            }
        });*/
    },
    //下拉刷新
    pulldownRefresh: function () {
        alert("下拉刷新")
    },
    scrollToBottom: function () {
        scrollToBottom();
    },
    bindEvent: function () {
        $("#ul-msglist").delegate(".msg-box", "click", function () {
            var item = $(this);
            var msgType = item.find("i.msg-info").attr("msgtype");
            var value = item.find("i.msg-info").attr("value");
            if (msgType == "5") {
                HealthBAT.DrKangPlayMusic(value);
            }
        });
    }
}


var chartObj = {
    /* 发送信息的内容 */
    contentMsg: function (content, messagetype, value,cfid, diseasename) {
        if (messagetype == 1) {//文字
            contents = "<i msgtype='" + messagetype + "' value='" + value + "'></i><div class=\"msg-txt\">" + content + "</div>";
        }
        else if (messagetype == 2) {//图片
            var img = "<img src='" + content + "'>";
            contents = "<i class=\"msg-info\" msgtype='" + messagetype + "'  value='" + value + "'></i><div class=\"msg-txt\">" + img + "</div>"
        }
        else if (messagetype == 4) {//处方
            if (!!cfid) {
                var detailurl = "/app/OrdonnanceDetail?id=" + cfid;
                contents = "<i class=\"msg-info\" msgtype='" + messagetype + "'  value='" + value + "'></i><div class=\"landscap-box\"><div class=\"landscap-head\"><i class=\"icon\"></i><b>处方单</b></div><div class=\"landscap-con\"><p>我给你制定了新的处方</p><p>处方名称：" + diseasename
                    + "</p><p>处方价格：免费</p><a class=\"read-detail\" href=\"" + detailurl + "\" cfid='" + cfid + "'>点击查看详情</a></div></div>";
            }
        }
        else if (messagetype == 5) {//发送声音
            var img = "<img style='height:20px;' src='" + G.DOMAIN.SLD+G.DOMAIN.FILE + "Content/images/module/webApp/kDoctor/icon-voice.png" + "'>";
            contents = "<i class=\"msg-info\" msgtype='" + messagetype + "'  value='" + value + "'></i><div class=\"msg-txt\" style='width:150px;'>" + img + "</div>"
        }
        return contents;
    },
    /* 添加信息 */
    addMsg: function (msgTxt, isme, photourl, msgtype, isnew) {
        var msgHtml;
        //本人发送的消息
        if (isme) {
            msgHtml = '<li class="oneself-msg clearfix">'
            if (msgtype == 4) {
                msgHtml = '<li class="oneself-msg plan-landscap clearfix">'
            }
        }
        //对方发送的消息
        else {
            msgHtml = '<li class="other-msg clearfix">'
            if (msgtype == 4) {
                msgHtml = '<li class="other-msg plan-landscap clearfix">'
            }
        }
        msgHtml += '<div class="msg-con">' +

            '<div class="msg-box">' + msgTxt + '</div>' +
            '</div>' +
            '</li>';
        //加载历史记录往上追加，新发的往下追加
        if (!isnew) {
            $('#ul-msglist').prepend(msgHtml);
        }
        else {
            $('#ul-msglist').append(msgHtml);
        }
    }
}

var scroll_right;	//

$(function () {
    msgBox.init();
    
    
    var wrapper = document.getElementById("wrapper");
    wrapper.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
    //滚动条初始化
    if(!scroll_right){
    		scroll_right= new IScroll('#wrapper', {
          probeType: 3,
            scrollX: false,
            scrollY: true,
            click: true
    	})
    }
    
    
    //按钮点击
//  $("#send").on("click",function(){
//      sendMsg({content:"哈哈哈哈"});
//      scroll_right.refresh();
//      scrollToBottom();
//  })
//  $("#recive").on("click",function(){
//      scrollToBottom();
//  })

})
//发送信息
/*
*obj={
* content:''，--输出内容
* icon:'',--头像
* msgType:1,--消息类型默认为1
* }
* */
var sendMsg = function (obj) {
    var content = obj.content;
    var icon = obj.icon;
    var msgType = 1;
    if (!!obj.msgType && typeof (obj.msgType) === "number") {
        msgType = obj.msgType;
    }
    var value = "";
    if (!!obj.value) {
        value = obj.value;
    }
    var msg = chartObj.contentMsg(content, msgType, value);
    if (!!icon==false) {
        icon = userIcon;
    }
    chartObj.addMsg(msg, true, icon, 1, true);
    scroll_right.refresh();
    scrollToBottom();
}

//接收信息
/*
*obj={
* content:''，--输出内容
* icon:'',--头像
* msgType:1,--消息类型默认为1
* }
* */
var receiveMsg = function (obj) {
    var content = obj.content;
    var icon = obj.icon;
    var msgType = 1;
    if (!!obj.msgType && typeof (obj.msgType) === "number") {
        msgType = obj.msgType;
    }
    var value = "";
    if (!!obj.value) {
        value = obj.value;
    }
    var msg = chartObj.contentMsg(content, msgType,value);
    if (!!icon == false) {
        icon = drKangIcon;
    }
    chartObj.addMsg(msg, false, icon, 1, true);
//  msgBox.scrollToBottom();
    scroll_right.refresh();
    scrollToBottom();
}


//显示更多详情
var showDetail = function (obj) {
    var txt = obj.content;
    if (!!txt) {
        $('.detail-more .detail-txt').html(txt);
        $('.detail-more').show();
    }
}


//隐藏更多详情
var closeDetail = function () {
    $('.detail-more').hide();
}


//消息滚动到底部
var scrollToBottom = function () {
    var h = $("#ul-msglist").height() - $(".container").height();
    if(h>0){
    	 scroll_right.scrollTo(0, -h);
    }
}
