var p = null;
window.onload = function()
{
	if(!parent.WinManage.WindowsList||parent.WinManage.WindowsList.length<1)
	{
		alert("非法调用");
				location.href = "http://www.hanxin1987216.com";
	}
	else
	{
		p = parent;
		if(uid)
		{
			var w = p.WinManage.GetWindow(uid,3);
			w.win.HideLoading();
			document.onclick = function()
			{
				w.win.Focus();
			};
		}
	}
	var inputs = $T("input");
	for(var i=0;i<inputs.length;i++)
	{
		if(inputs[i].type=="text"||inputs[i].type=="password")
		{
			inputs[i].focus();
			break;
		}
	}
}
function winMax(id,t)
{
	var w = p.WinManage.GetWindow(id,t);
	if(w&&w.isMin)w.win.Minimize();
}
function winClose(evt)
{
	Evt.NoBubble(evt||event);
	if(!uid)return;
	var w = p.WinManage.GetWindow(uid,3);
	w.win.Close();
}
function showLoading()
{
	if(!uid)return;
	p.WinManage.GetWindow(uid,3).win.ShowLoading();
}