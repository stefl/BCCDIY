jQuery.fn.reverse=Array.prototype.reverse;String.prototype.linkify=function()
{return this.replace(/[A-Za-z]+:\/\/[A-Za-z0-9-_]+\.[A-Za-z0-9-_:%&\?\/.=]+/g,function(m)
{return m.link(m);});};String.prototype.linkuser=function()
{return this.replace(/[@]+[A-Za-z0-9-_]+/g,function(u)
{var username=u.replace("@","")
return u.link("http://twitter.com/"+username);});};String.prototype.linktag=function()
{return this.replace(/[#]+[A-Za-z0-9-_]+/,function(t)
{var tag=t.replace("#","%23")
return t.link("http://search.twitter.com/search?q="+tag);});};function fetch_tweets(elem)
{elem=$(elem);input=elem.attr('title');lang=elem.attr('lang');if(input!=window.monitter['text-'+input])
{window.monitter['last_id'+input]=0;window.monitter['text-'+input]=input;window.monitter['count-'+input]=12;;}
if(window.monitter['count-'+input]>10)
{elem.prepend('<div class="tweet"><img src="http://monitter.com/widget/favicon.gif" align="absmiddle" />real time twitter by: <a href="http://monitter.com" target="_blank">monitter.com</a></div>');window.monitter['count-'+input]=0;}
var url="http://search.twitter.com/search.json?q="+input+"&lang="+lang+"&rpp="+rrp+"&since_id="+window.monitter['last_id'+input]+"&callback=?";$.getJSON(url,function(json)
{$('div.tweet:gt('+window.monitter['limit']+')',elem).each(function(){$(this).fadeOut('slow')});$(json.results).reverse().each(function()
{if($('#tw'+this.id,elem).length==0)
{window.monitter['count-'+input]++;var thedate=new Date(Date.parse(this.created_at));var thedatestr=thedate.getHours()+':'+thedate.getMinutes();var divstr='<div id="tw'+this.id+'" class="tweet"><img width="48" height="48" src="'+this.profile_image_url+'" ><p class="text">'+this.text.linkify().linkuser().linktag()+'<br />&nbsp;<b><a href="http://twitter.com/'+this.from_user+'" target="_blank">'+this.from_user+'</a></b> &nbsp;-&nbsp;<b>'+thedatestr+'</b></p></div>';window.monitter['last_id'+input]=this.id;elem.prepend(divstr);$('#tw'+this.id,elem).hide();$('#tw'+this.id+' img',elem).hide();$('#tw'+this.id+' img',elem).fadeIn(4000);$('#tw'+this.id,elem).fadeIn('slow');}});input=escape(input);rrp=1;setTimeout(function(){fetch_tweets(elem)},2000);});return(false);}
$(document).ready(function(){window.monitter={};$('.monitter').each(function(e){rrp=6;fetch_tweets(this);});});