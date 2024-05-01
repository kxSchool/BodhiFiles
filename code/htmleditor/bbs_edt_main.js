//html输出
function output(dat,templ,b)
{
	for(var i=0;i<dat.length;i++)
	{
	  var d = dat[i];
	  if(d.join)
	  {  
		for(var j=0;j<d.length;j++)
		  if (templ[j*2+1])
			templ[j*2+1] = d[j];
		if(b) alert(templ.join(""));
		document.write(templ.join(""));
	  }
	  else document.write(d); 
	}
}
//B I U
var commFunc = " onmousedown=OnTBMouseDown(this) onmouseover=OnTBMouseOver(this) onmouseout=OnTBMouseOut(this) ";
var commAttr = ' style="position:absolute;clip:rect($rect$);margin:$margin$;" title="$title$" ';
var commHead = ' <img src="/htmleditor/images/editoricon.gif" '+ commAttr;
var commHeadMask = ' <img src="/htmleditor/images/editoricon_mask.gif" ' + commAttr;
var sComm = commHead + commFunc;



//模块结构: 1.基础函数 2.接口定义 3.事件函数 4.HTML编辑框 5.全局事件绑定 6.全局变量声明
//基础函数
function GetDoc(win){ return (win?win:window).document;}
function S(i,win) {return GetDoc(win).getElementById(i);}
function F(sID,win) //sunny for firefox
{	
	if( sID == "" || sID == null ) return null;
	var frame = S(sID,win);
	if( !frame) return null;
	return frame.contentWindow?frame.contentWindow:(win?win:window).frames[sID];
}
function Disp(obj,flag) // 0 隐藏,1显示
{
	if(obj){ obj.style.display = flag?"":"none";}
}
function getPosX(e)
{
	var l=e.offsetLeft;
	while(e=e.offsetParent){
		l+=e.offsetLeft;
	}
	return l;
}
function getPosY(e)
{
	var t=e.offsetTop;
	while(e=e.offsetParent){
		t+=e.offsetTop;
	}
	return t;
}
String.prototype.trim = function(){
	return this.replace(/(^\s*)|(\s*$)/g, "");
};

function ExecCmd(type, para){
	LoadPos();
	var f = F("HtmlEditor");
	var sAlert = "";
	if(!gIsIE)
	{
		switch(type){
			case "Cut":
				sAlert = "你的浏览器安全设置不允许编辑器自动执行剪切操作,请使用键盘快捷键(Ctrl+X)来完成";
				break;
			case "Copy":
				sAlert = "你的浏览器安全设置不允许编辑器自动执行拷贝操作,请使用键盘快捷键(Ctrl+C)来完成";
				break;
			case "Paste":
				sAlert = "你的浏览器安全设置不允许编辑器自动执行粘贴操作,请使用键盘快捷键(Ctrl+V)来完成";
				break;
		}
	}
	if(sAlert != ""){
		alert(sAlert);
		return;
	}
	f.focus();
	var doc = f.document;
	if(!para)
	{
		gIsIE?doc.execCommand(type):doc.execCommand(type,false,false);
	}
	else
	{
		//为了图片插入后把焦点放到图片后面
		if (type == "InsertImage" && gIsIE) {
			var r = doc.selection.createRange();
		}

		doc.execCommand(type,false,para);

		//为了图片插入后把焦点放到图片后面
		if (type == "InsertImage" && gIsIE) {
			r.move("character");
			r.select();
		}
	}
	f.focus();
}
function IsValidURL(str)
{
	return ( ( str.indexOf("://") > 1 ) || (str.indexOf(":\\") > 1) );
}
function addHyperLink() {
	var f = F("HtmlEditor");
	//哈哈,终于找到兼容mf噶方法
	var sel = f.document.selection != null ? f.document.selection.createRange().text : f.document.getSelection();
	if(sel.length>0)
	{
		var sURL=window.prompt("请输入链接的目标地址 (	e.g. http://www.qq.com/):", "http://");	
		if(sURL != null)
		{
			if( !IsValidURL(sURL))
			{
				sURL= "http://" + sURL;
			}
			F("HtmlEditor").document.execCommand("CreateLink",false,sURL);
		}
	}
	else
	{
		alert("请先选择要连接的文字。");
	}
}
function addImage()
{
	var width="380px", height="150px";
	//modify by angusdu 2006-10-13
	//showModalDialog("uploadImg.htm", window, vfeature);
	var url = "uploadImg.htm";
	if(gIsIE)//IE   
	{
		window.showModalDialog(url,window,"dialogWidth:" + width + ";dialogHeight:" + height + ";center:Yes;help:off;status:no;scroll:no");   
	}   
	else 
	{
		window.open(url,window,"width="+width+",height="+height+",menubar=no,toolbar=no,location=no,scrollbars=no,status=no,modal=yes");   
	}  
}
function getIEVer(){
	var s = navigator.userAgent;
	if(s.indexOf("MSIE")>-1)
		return parseFloat(s.split(";")[1].replace("MSIE",""));
}
//接口定义
function editor()
{
 this.get_contents = GetContents;
 this.get_plaincontents = GetPlainContents;
 this.put_contents = PutContents;
 this.put_plaincontents = PutPlainContents;
 this.put_firstline = PutFirstLine;
}
function PutFirstLine(s) 
{
	return;
}
function GetContents() {
	if (curEditor == "source")
		return S("sourceEditor").value;
	return HtmlEditor.document.body.innerHTML;
}
function GetPlainContents() {
	//modify by angusdu 2006-10-11
	var bc = HtmlEditor.document.body;
	if (curEditor == "source")
		bc.innerHTML = S("sourceEditor").value;
	if (bc.innerText != null) {
		return bc.innerText;
	}
	else {
		return bc.textContent;
	}
}
function PutContents(contents)
{
	HtmlEditor.document.designMode="on";
	HtmlEditor.document.body.innerHTML = contents;
	SetDiv();
	S("sourceEditor").value = HtmlEditor.document.body.innerHTML;
}

function PutPlainContents(contents)
{
	HtmlEditor.document.designMode="on";
	//modify by angusdu 2006-10-12
	var bc = HtmlEditor.document.body;
	if (bc.innerText != null) {
		bc.innerText = contents;
	}
	else {
		bc.textContent = contents;
	}
	S("sourceEditor").value = HtmlEditor.document.body.innerHTML;
}
//==========
//事件函数
function OnLoad() {
	try
	{
		if( !window.top.isFireFox)
		{
			F("HtmlEditor").document.designMode="on";
		}
		gLoaded = true;
		SetEditable();
		SetFrameClick();
		document.parentWindow.onclick=HideMenu();
	}catch(e){
	}
	setTimeout(SetColor,100); //--sunny 一开始就画颜色表,那么第一次就不会慢了
}
var editorTxtRange = null;
function SavePos() {
	if (document.selection) {
		editorTxtRange = F("HtmlEditor").document.selection.createRange();
	}
}
function LoadPos() {
	if (editorTxtRange) {
		editorTxtRange.select();
		editorTxtRange = null;
	}
}
// sunny : foreColor与backColor只是负责弹出ColorBoard,不需要ExecCmd (此时ExecCmd会导致白色)
function OnForeColor(e) {
	SavePos();
	HideMenu();
	var sColor = DispColorBrd(e);
	gSetColorType = "foreColor";
	if(gIsIE && gIEVer < 6)
	{
		ExecCmd(gSetColorType, sColor);
	}
	return ; 
}
function OnBackColor(e){
	SavePos();
	HideMenu();
	var sColor = DispColorBrd(e,1);
	gSetColorType = (gIsIE)?"backColor":"hilitecolor";
	if(gIsIE && gIEVer < 6)
	{
		ExecCmd(gSetColorType, sColor);
	}
	return 
}

function OnMo(e) {
	SavePos();	
	HideMenu();
	var sMo = DispMoBrd(e);
	if(gIsIE && gIEVer < 6 && sMo != null)
	{
		ExecCmd("InsertImage",sMo);
	}
	return ; 
}
function OnTBMouseOver(obj) {
	SetBorderMouse(obj,0);
} 
function OnTBMouseDown(obj) {
	SetBorderMouse(obj,1);
}
function OnTBMouseOut(obj) {
	obj.style.border="none";
}
//HTML编辑框
function SetEditable(){
	var doc = window.frames["HtmlEditor"].document;
	doc.designMode="on";
	if(!gIsIE) {
		// angus:难怪，察看ff的文档发现，如此说明： use false to use CSS, true to use HTML
		doc.execCommand("useCSS",false, false);
	}
}
function SetFrameClick(){
	var frm = window.frames["HtmlEditor"];
	var doc = frm.document;
	doc.onmousemove = function(){
		window.onblur();
	};
	doc.onclick = function(){
		//alert("aa")
		HideMenu();
	};
	doc.onkeydown = function()
	{
		if(frm.event.keyCode == 13 && frm.event.ctrlKey)
		{
			if(parent.DoCtrlEnter) parent.DoCtrlEnter();
		}
		//top.frames["jsFrame"].gIsEdited = true;
	};
}
function SetDiv()
{

	var loc = "" + window.parent.location;
	if(loc.indexOf("setting") > 0)
	{
		Disp(document.getElementById("add_pic_id"),0);
/*		removed by angusdu 2006-11-17
		if( !/^<DIV>&nbsp;<\/DIV>/.test(HtmlEditor.document.body.innerHTML))
		{
			HtmlEditor.document.body.innerHTML = HtmlEditor.document.body.innerHTML+"<DIV>&nbsp;</DIV>";
		}
*/		S("HtmlEditor").style.height = gIsIE ? "182px" : "188px";
		S("sourceEditor").style.height = "184px";
		S("sourceEditor").style.width = "100%";
		S("htmlbtn").style.marginLeft = "393px";
	}
	else if (loc.indexOf("compose_card") > 0)
	{
		Disp(document.getElementById("add_pic_id"),0);
		S("HtmlEditor").style.height = "181px";
		S("sourceEditor").style.height = "183px";
		S("sourceEditor").style.width = "100%";
	}
	else if(loc.indexOf("compose") > 0)
	{
		if(GetSetting())
		{
			if( HtmlEditor.document.getElementById("QQMail_signature") )
			{
				HtmlEditor.document.getElementById("QQMail_signature").innerHTML = GetSetting().nSignature;
			}
			
		}
	}

	var doc = F("HtmlEditor").document;
	doc.designMode="on";
		//HtmlEditor.document.body.innerHTML="<DIV>&nbsp;</DIV>"+HtmlEditor.document.body.innerHTML;
	if(doc.body)
	{
		doc.body.style.background = '#ffffff';
		doc.body.style.fontSize = '12px';
		doc.body.style.fontFamily = 'verdana';
		try
		{
			if( HtmlEditor.document.body.innerHTML.indexOf("<QQMAILSTATIONERY>") > -1)
			{
				doc.body.style.margin = '0.5% 0 0 0';
				doc.body.style.background = '#fff';
				doc.body.style.fontSize = '12px';
				return;
			} 
				
		}catch(e)
		{}
		doc.body.style.margin = '4px';
	}
}
function SetColor(){
	var dvForeColor =S("dvForeColor");
	if(dvForeColor.getElementsByTagName("TABLE").length == 1){
		dvForeColor.innerHTML = paintCube();//+ dvForeColor.innerHTML;
		//window.top.document.write(dvForeColor.innerHTML);
	}
}
function SetMo(){
	var dvMo =S("dvMo");
	dvMo.innerHTML = moCube();
}
//工具栏
//add by angusdu 2006-10-13
function showDialog(url, type, feature)   
{   
	if(gIsIE)//IE   
	{      
		return window.showModalDialog(url,type,feature);   
	}   
	else   
	{   
		//modelessDialog可以将modal换成dialog=yes   
		feature   ="width=300,height=200,menubar=no,toolbar=no,location=no,";   
		feature+="scrollbars=no,status=no,modal=yes";     
		window.open(url,type,feature);   
	}   
} 
function DispColorBrd(e,isBC){
	if(gIEVer<6 && gIsIE){
		var arr = showModalDialog("color_slt.html", "", "font-family:Verdana; font-size:12; status:no; dialogWidth:17em; dialogHeight:14em");
		if (arr != null) return arr;
		return;
	}
	var dvForeColor =S("dvForeColor");
	SetColor();
	Disp(dvForeColor,1);
	dvForeColor.style.left = (isBC?bcL:fcL) + "px";
	dvForeColor.style.top = 30 + "px";
	dvForeColor.focus();
	e.cancelBubble =true;
	return true;
}
function DispMoBrd(e) {
	if(gIEVer<6 && gIsIE){
		var arr = showModalDialog("mo_slt.html", "", "font-family:Verdana; font-size:12; status:no; dialogWidth:265px; dialogHeight:190px");
		if (arr != null) return arr;
		return;
	}
	var dvMo =S("dvMo");
	SetMo();
	Disp(dvMo, 1);
	dvMo.focus();
	e.cancelBubble =true;
	return true;
}
function CommCheck(obj,str,func)
{
	if (obj.id == str) {
		return true;
	}
	if(obj.parentNode) {
		return func(obj.parentNode);
	}
	return false;
}
function CommObjectCheck(obj, inObj)
{
	if (obj == inObj)
	{
		return true;
	}
	if(obj.parentNode) {
		return CommObjectCheck(obj.parentNode, inObj);
	}
	return false;
}
function HideMenu()
{
	var elementTable=["fontface","fontsize","dvForeColor","dvPortrait","divAlign","divList","dvMo"];
	for(var i=0;i<elementTable.length;i++)
	  Disp(S(elementTable[i]),0);
}
function IsInColorBrd(obj){
	return CommCheck(obj,"dvForeColor",IsInColorBrd);
}
function IsInFontFaceBrd(obj){
	return CommCheck(obj,"fontface",IsInFontFaceBrd);
}
function IsInFontSizeBrd(obj){
	return CommCheck(obj,"fontsize",IsInFontSizeBrd);
}
function IsInMoBrd(obj){
	return CommCheck(obj,"dvMo",IsInMoBrd);
}
function SetBorderMouse(obj,flag) // flag : 0 over 1 out 
{
	var d = [ 
	 ["1px solid #fff","1px solid #fff","1px solid #F3F8FC","1px solid #F3F8FC"]
	,["1px solid #ccc","1px solid #ccc","1px solid #F3F8FC","1px solid #ccc"]][flag];
	obj.style.borderTop=d[0];
	obj.style.borderRight=d[1];
	obj.style.borderBottom=d[2];
	obj.style.borderLeft=d[3];
}
function DispBoard(element,displayValue,nLeft) {
	if(gIEVer<=5.01 && gIsIE){
		if(element == "fontface"){
			var sReturnValue = showModalDialog("fontface_slt.html","", "font-family:Verdana; font-size:12; status:no; unadorned:yes; scroll:no; resizable:yes;dialogWidth:112px; dialogHeight:271px");;
			ExecCmd("fontname",sReturnValue);
		}else if(element == "fontsize"){
			var sReturnValue = showModalDialog("fontsize_slt.html","", "font-family:Verdana; font-size:12; status:no; unadorned:yes; scroll:no; resizable:yes;dialogWidth:130px; dialogHeight:250px");;
			ExecCmd("fontsize",sReturnValue);
		}
		return;
	}
	HideMenu();
	if ( typeof element == "string" )
		element = S(element);
	if (element == null) return;
	element.style.display = displayValue;
	SavePos();
	if(gIsIE){
		var e = event;
	}else{
		var e = ev;
	}
	var iX = e.clientX;
	var iY = e.clientY;
	Disp(element,1);
	element.style.left = ((null==nLeft)?(iX-30):nLeft) + "px";
	element.style.top = 30 + "px";
	setTimeout("document.getElementById('"+element.id+"').focus();", 500);
	return true;
}
function SaveEvent(e){
	ev = e;
}
//qqmail增加的函数

function fSetReplyContent(){
	try{
		win.fSetComposeContent(win.gReplyContent);
		window.frames["HtmlEditor"].focus();
	}catch(exp){
		window.setTimeout('fSetReplyContent()',1000);
	}
	win.gReplyContent = null;
}

function setContentType(ContentType)
{
	alert("setContentType");
	if(ContentType=="text")
	{
		PutContents(GetPlainContents());
	}
	window.parent.contenttype.value=ContentType;

}

function GetSetting()
{
	try
	{
		return window.top.GetApp().setting;
	}catch(e)
	{}
	return null;
}

function BrdBlur() {
	if (gIsIE)
	{
		if (!CommObjectCheck(document.activeElement, event.srcElement)) {
			setTimeout("LoadPos();HideMenu();", 10);
		}
	}
}

  
//全局事件绑定
window.onblur =function(){
	if(!gIsIE){
		HideMenu();
	}
};
window.onerror = function(){
	return true;
};
document.onmousemove = function(e){
/*	if(gIsIE) var el = event.srcElement;
	else var el = e.target;
	var tdView = S("tdView");
	var tdColorCode = S("tdColorCode");
	var dvForeColor =S("dvForeColor");
	var dvPortrait =S("dvPortrait");
	var fontsize =S("fontsize");
	var fontface =S("fontface");
	if(el.tagName == "IMG"){
		try{
			if(IsInColorBrd(el)){
				//tdView.bgColor = el.parentNode.bgColor;
				//tdColorCode.innerHTML = el.parentNode.bgColor
			}
		}catch(e){}
	}else{
		return;
		Disp(dvForeColor,0);
		if(!IsInFontFaceBrd(el)) Disp(fontface,0);
		if(!IsInFontSizeBrd(el)) Disp(fontsize,0);
	}
	*/
};
function DectoHex(num) {
  var i,j=20,str = "#",N="ABCDEF";
  while(j >= 0) {
    i = (num >> j)%16;
    str += (i>9)?N.charAt(i-10):i;
    j -= 4;
  }
  return str;
}
function GetColorFromBg(bg)
{
	var i = bg.indexOf("("),j=bg.indexOf(")"),s=bg.substr(i+1,j-i-1).split(",");
	return DectoHex((s[0]<<16) + (s[1]<<8) + parseInt(s[2]));
}
document.onclick = function(e){
	if(gIsIE) var el = event.srcElement;
	else var el = e.target;
	var dvForeColor =S("dvForeColor");
	var dvPortrait =S("dvPortrait");

	try{
		
		if(IsInColorBrd(el)){
			//var _bgColor = (el.tagName == "IMG") ? el.parentNode.bgColor : el.bgColor;
			var t = el;
			if( t.tagName != "IMG")	{
				t = t.getElementsByTagName("IMG")[0];
			}
			var _bgColor = t.style.background+"";
			if(_bgColor.indexOf(")") > -1) //firefox
			{
				_bgColor = GetColorFromBg(_bgColor);
			}
			ExecCmd(gSetColorType, _bgColor);
			Disp(dvForeColor,0);
			return;
		}

		if (IsInMoBrd(el)) {
			var t = el;
			if( t.tagName == "TD")	{
				t = el.getElementsByTagName("IMG")[0];
			}
			if (t.tagName == "IMG" && t.attributes["data"] != null)
			{
				ExecCmd("InsertImage", giMoBaseUrl + t.attributes["data"].nodeValue);
				Disp(S("dvMo"), 0);
			}
			return;
		}
	}catch(e){}

	HideMenu();
	var idTable = [
	 "imgFontface","fontface"
	,"imgFontsize","fontsize"
	,"imgFontColor","fontsize"
	,"imgBackColor","dvForeColor"
    ,"imgFace","dvPortrait"
    ,"imgAlign","divAlign"
    ,"imgList","divList"];
    for(var i=0;i<idTable.length;i+=2){
      if( idTable[i]==el.id)
      {
        var obj = S(idTable[i+1]);
        obj?(obj.style.display = ""):0;
        break;
      }
    }
};
//全局变量
public_description = new editor;
var gSetColorType = ""; 
var gIsIE = document.all; 
var gIEVer = getIEVer();
var gLoaded = false;
var ev = null;

//增加源代码编辑器...
//add by angusdu 2006-11-21
var curEditor = "Html";
function EnableToolBar(flag) {
	var tools = document.getElementsByName("tool_mask");
	for (i = tools.length - 1; i >= 0; i--) {
		Disp(tools[i], flag);
	}
	if (S("add_pic_id").style.display == "") {
		Disp(S("add_pic_mask_id"), flag);
	}
}
function ChangeEditor() {
	if (curEditor == "Html") {
		curEditor = "source";
		Disp(S("sourceEditor"), 1);
		Disp(S("HtmlEditor"), 0);
		S("sourceEditor").value = HtmlEditor.document.body.innerHTML;
		S("sourceEditor").focus();
		S("htmlbtn").title = "图文编辑";
		S("htmlbtn").innerHTML = "<a class=abtn href=javascript:void(0);>&lt;普通模式&gt;</a>";
		EnableToolBar(1);
	}
	else {
		curEditor = "Html";
		Disp(S("sourceEditor"), 0);
		Disp(S("HtmlEditor"), 1);
		HtmlEditor.document.body.innerHTML = S("sourceEditor").value;
		F("HtmlEditor").focus();
		S("htmlbtn").title = "编辑HTML源码";
		S("htmlbtn").innerHTML = "<a class=abtn href=javascript:void(0);>&lt;HTML模式&gt;</a>";
		EnableToolBar(0);
	}
}
function GetEditorType() {
	return (curEditor == "Html" ? "Html" : "source");
}

//增加对编辑器的高度修改接口
var gMinSize = 0;
function GetMinSize() {
	if (!gMinSize) {
		gMinSize = parseInt(S("HtmlEditor").style.height);
	}
	return gMinSize;
}
function AddElementHeight(el, l) {
	el.style.height = (parseInt(el.style.height) + l) + "px";
}
function StretchEditor(bIsLarge, l, frameid) {
	//默认伸缩长度为50px
	l = (l != null ? l : 50);
	var pw = window.parent;
	var pwif = pw.document.getElementsByTagName("iframe");
	for (i = pwif.length - 1; i >= 0; i--) {
		if (pwif[i].id && (frameid ? pwif[i].id == frameid : GetDoc(pw.frames[pwif[i].id]).body.innerHTML == GetDoc().body.innerHTML)) {
			if (parseInt(S("HtmlEditor").style.height) <= GetMinSize() && !bIsLarge) {
				return;
			}
			l = (bIsLarge ? l : (-1)*l);
			AddElementHeight(pwif[i], l);
			AddElementHeight(S("HtmlEditor"), l);
			AddElementHeight(S("sourceEditor"), l);
			return ;
		}
	}
}
