"use strict";var Vr=Object.defineProperty;var An=t=>{throw TypeError(t)};var Wr=(t,e,n)=>e in t?Vr(t,e,{enumerable:!0,configurable:!0,writable:!0,value:n}):t[e]=n;var ut=(t,e,n)=>Wr(t,typeof e!="symbol"?e+"":e,n),Dn=(t,e,n)=>e.has(t)||An("Cannot "+n);var tt=(t,e,n)=>(Dn(t,e,"read from private field"),n?n.call(t):e.get(t)),Pe=(t,e,n)=>e.has(t)?An("Cannot add the same private member more than once"):e instanceof WeakSet?e.add(t):e.set(t,n),Ie=(t,e,n,r)=>(Dn(t,e,"write to private field"),r?r.call(t,n):e.set(t,n),n);(function(){var t=window.Document.prototype.createElement,e=window.Document.prototype.createElementNS,n=window.Document.prototype.importNode,r=window.Document.prototype.prepend,o=window.Document.prototype.append,s=window.DocumentFragment.prototype.prepend,l=window.DocumentFragment.prototype.append,f=window.Node.prototype.cloneNode,v=window.Node.prototype.appendChild,p=window.Node.prototype.insertBefore,g=window.Node.prototype.removeChild,y=window.Node.prototype.replaceChild,E=Object.getOwnPropertyDescriptor(window.Node.prototype,"textContent"),_=window.Element.prototype.attachShadow,k=Object.getOwnPropertyDescriptor(window.Element.prototype,"innerHTML"),x=window.Element.prototype.getAttribute,A=window.Element.prototype.setAttribute,j=window.Element.prototype.removeAttribute,$=window.Element.prototype.toggleAttribute,C=window.Element.prototype.getAttributeNS,L=window.Element.prototype.setAttributeNS,$t=window.Element.prototype.removeAttributeNS,D=window.Element.prototype.insertAdjacentElement,N=window.Element.prototype.insertAdjacentHTML,J=window.Element.prototype.prepend,O=window.Element.prototype.append,M=window.Element.prototype.before,W=window.Element.prototype.after,Q=window.Element.prototype.replaceWith,nt=window.Element.prototype.remove,rt=window.HTMLElement,it=Object.getOwnPropertyDescriptor(window.HTMLElement.prototype,"innerHTML"),ht=window.HTMLElement.prototype.insertAdjacentElement,Gt=window.HTMLElement.prototype.insertAdjacentHTML,yn=new Set;"annotation-xml color-profile font-face font-face-src font-face-uri font-face-format font-face-name missing-glyph".split(" ").forEach(function(i){return yn.add(i)});function wn(i){var a=yn.has(i);return i=/^[a-z][.0-9_a-z]*-[-.0-9_a-z]*$/.test(i),!a&&i}var Or=document.contains?document.contains.bind(document):document.documentElement.contains.bind(document.documentElement);function B(i){var a=i.isConnected;if(a!==void 0)return a;if(Or(i))return!0;for(;i&&!(i.__CE_isImportDocument||i instanceof Document);)i=i.parentNode||(window.ShadowRoot&&i instanceof ShadowRoot?i.host:void 0);return!(!i||!(i.__CE_isImportDocument||i instanceof Document))}function je(i){var a=i.children;if(a)return Array.prototype.slice.call(a);for(a=[],i=i.firstChild;i;i=i.nextSibling)i.nodeType===Node.ELEMENT_NODE&&a.push(i);return a}function Oe(i,a){for(;a&&a!==i&&!a.nextSibling;)a=a.parentNode;return a&&a!==i?a.nextSibling:null}function Re(i,a,c){for(var h=i;h;){if(h.nodeType===Node.ELEMENT_NODE){var u=h;a(u);var d=u.localName;if(d==="link"&&u.getAttribute("rel")==="import"){if(h=u.import,c===void 0&&(c=new Set),h instanceof Node&&!c.has(h))for(c.add(h),h=h.firstChild;h;h=h.nextSibling)Re(h,a,c);h=Oe(i,u);continue}else if(d==="template"){h=Oe(i,u);continue}if(u=u.__CE_shadowRoot)for(u=u.firstChild;u;u=u.nextSibling)Re(u,a,c)}h=h.firstChild?h.firstChild:Oe(i,h)}}function pe(){var i=!(vt==null||!vt.noDocumentConstructionObserver),a=!(vt==null||!vt.shadyDomFastWalk);this.m=[],this.g=[],this.j=!1,this.shadyDomFastWalk=a,this.I=!i}function Zt(i,a,c,h){var u=window.ShadyDOM;if(i.shadyDomFastWalk&&u&&u.inUse){if(a.nodeType===Node.ELEMENT_NODE&&c(a),a.querySelectorAll)for(i=u.nativeMethods.querySelectorAll.call(a,"*"),a=0;a<i.length;a++)c(i[a])}else Re(a,c,h)}function Rr(i,a){i.j=!0,i.m.push(a)}function Fr(i,a){i.j=!0,i.g.push(a)}function Fe(i,a){i.j&&Zt(i,a,function(c){return Ft(i,c)})}function Ft(i,a){if(i.j&&!a.__CE_patched){a.__CE_patched=!0;for(var c=0;c<i.m.length;c++)i.m[c](a);for(c=0;c<i.g.length;c++)i.g[c](a)}}function pt(i,a){var c=[];for(Zt(i,a,function(u){return c.push(u)}),a=0;a<c.length;a++){var h=c[a];h.__CE_state===1?i.connectedCallback(h):ve(i,h)}}function ot(i,a){var c=[];for(Zt(i,a,function(u){return c.push(u)}),a=0;a<c.length;a++){var h=c[a];h.__CE_state===1&&i.disconnectedCallback(h)}}function bt(i,a,c){c=c===void 0?{}:c;var h=c.J,u=c.upgrade||function(m){return ve(i,m)},d=[];for(Zt(i,a,function(m){if(i.j&&Ft(i,m),m.localName==="link"&&m.getAttribute("rel")==="import"){var w=m.import;w instanceof Node&&(w.__CE_isImportDocument=!0,w.__CE_registry=document.__CE_registry),w&&w.readyState==="complete"?w.__CE_documentLoadHandled=!0:m.addEventListener("load",function(){var b=m.import;if(!b.__CE_documentLoadHandled){b.__CE_documentLoadHandled=!0;var S=new Set;h&&(h.forEach(function(I){return S.add(I)}),S.delete(b)),bt(i,b,{J:S,upgrade:u})}})}else d.push(m)},h),a=0;a<d.length;a++)u(d[a])}function ve(i,a){try{var c=a.ownerDocument,h=c.__CE_registry,u=h&&(c.defaultView||c.__CE_isImportDocument)?me(h,a.localName):void 0;if(u&&a.__CE_state===void 0){u.constructionStack.push(a);try{try{if(new u.constructorFunction!==a)throw Error("The custom element constructor did not produce the element being upgraded.")}finally{u.constructionStack.pop()}}catch(b){throw a.__CE_state=2,b}if(a.__CE_state=1,a.__CE_definition=u,u.attributeChangedCallback&&a.hasAttributes()){var d=u.observedAttributes;for(u=0;u<d.length;u++){var m=d[u],w=a.getAttribute(m);w!==null&&i.attributeChangedCallback(a,m,null,w,null)}}B(a)&&i.connectedCallback(a)}}catch(b){Ht(b)}}pe.prototype.connectedCallback=function(i){var a=i.__CE_definition;if(a.connectedCallback)try{a.connectedCallback.call(i)}catch(c){Ht(c)}},pe.prototype.disconnectedCallback=function(i){var a=i.__CE_definition;if(a.disconnectedCallback)try{a.disconnectedCallback.call(i)}catch(c){Ht(c)}},pe.prototype.attributeChangedCallback=function(i,a,c,h,u){var d=i.__CE_definition;if(d.attributeChangedCallback&&-1<d.observedAttributes.indexOf(a))try{d.attributeChangedCallback.call(i,a,c,h,u)}catch(m){Ht(m)}};function bn(i,a,c,h){var u=a.__CE_registry;if(u&&(h===null||h==="http://www.w3.org/1999/xhtml")&&(u=me(u,c)))try{var d=new u.constructorFunction;if(d.__CE_state===void 0||d.__CE_definition===void 0)throw Error("Failed to construct '"+c+"': The returned value was not constructed with the HTMLElement constructor.");if(d.namespaceURI!=="http://www.w3.org/1999/xhtml")throw Error("Failed to construct '"+c+"': The constructed element's namespace must be the HTML namespace.");if(d.hasAttributes())throw Error("Failed to construct '"+c+"': The constructed element must not have any attributes.");if(d.firstChild!==null)throw Error("Failed to construct '"+c+"': The constructed element must not have any children.");if(d.parentNode!==null)throw Error("Failed to construct '"+c+"': The constructed element must not have a parent node.");if(d.ownerDocument!==a)throw Error("Failed to construct '"+c+"': The constructed element's owner document is incorrect.");if(d.localName!==c)throw Error("Failed to construct '"+c+"': The constructed element's local name is incorrect.");return d}catch(m){return Ht(m),a=h===null?t.call(a,c):e.call(a,h,c),Object.setPrototypeOf(a,HTMLUnknownElement.prototype),a.__CE_state=2,a.__CE_definition=void 0,Ft(i,a),a}return a=h===null?t.call(a,c):e.call(a,h,c),Ft(i,a),a}function Ht(i){var a="",c="",h=0,u=0;i instanceof Error?(a=i.message,c=i.sourceURL||i.fileName||"",h=i.line||i.lineNumber||0,u=i.column||i.columnNumber||0):a="Uncaught "+String(i);var d=void 0;ErrorEvent.prototype.initErrorEvent===void 0?d=new ErrorEvent("error",{cancelable:!0,message:a,filename:c,lineno:h,colno:u,error:i}):(d=document.createEvent("ErrorEvent"),d.initErrorEvent("error",!1,!0,a,c,h),d.preventDefault=function(){Object.defineProperty(this,"defaultPrevented",{configurable:!0,get:function(){return!0}})}),d.error===void 0&&Object.defineProperty(d,"error",{configurable:!0,enumerable:!0,get:function(){return i}}),window.dispatchEvent(d),d.defaultPrevented||console.error(i)}function En(){var i=this;this.g=void 0,this.F=new Promise(function(a){i.l=a})}En.prototype.resolve=function(i){if(this.g)throw Error("Already resolved.");this.g=i,this.l(i)};function kn(i){var a=document;this.l=void 0,this.h=i,this.g=a,bt(this.h,this.g),this.g.readyState==="loading"&&(this.l=new MutationObserver(this.G.bind(this)),this.l.observe(this.g,{childList:!0,subtree:!0}))}function Cn(i){i.l&&i.l.disconnect()}kn.prototype.G=function(i){var a=this.g.readyState;for(a!=="interactive"&&a!=="complete"||Cn(this),a=0;a<i.length;a++)for(var c=i[a].addedNodes,h=0;h<c.length;h++)bt(this.h,c[h])};function Y(i){this.s=new Map,this.u=new Map,this.C=new Map,this.A=!1,this.B=new Map,this.o=function(a){return a()},this.i=!1,this.v=[],this.h=i,this.D=i.I?new kn(i):void 0}Y.prototype.H=function(i,a){var c=this;if(!(a instanceof Function))throw new TypeError("Custom element constructor getters must be functions.");$n(this,i),this.s.set(i,a),this.v.push(i),this.i||(this.i=!0,this.o(function(){return Tn(c)}))},Y.prototype.define=function(i,a){var c=this;if(!(a instanceof Function))throw new TypeError("Custom element constructors must be functions.");$n(this,i),xn(this,i,a),this.v.push(i),this.i||(this.i=!0,this.o(function(){return Tn(c)}))};function $n(i,a){if(!wn(a))throw new SyntaxError("The element name '"+a+"' is not valid.");if(me(i,a))throw Error("A custom element with name '"+(a+"' has already been defined."));if(i.A)throw Error("A custom element is already being defined.")}function xn(i,a,c){i.A=!0;var h;try{var u=c.prototype;if(!(u instanceof Object))throw new TypeError("The custom element constructor's prototype is not an object.");var d=function(I){var Pt=u[I];if(Pt!==void 0&&!(Pt instanceof Function))throw Error("The '"+I+"' callback must be a function.");return Pt},m=d("connectedCallback"),w=d("disconnectedCallback"),b=d("adoptedCallback"),S=(h=d("attributeChangedCallback"))&&c.observedAttributes||[]}catch(I){throw I}finally{i.A=!1}return c={localName:a,constructorFunction:c,connectedCallback:m,disconnectedCallback:w,adoptedCallback:b,attributeChangedCallback:h,observedAttributes:S,constructionStack:[]},i.u.set(a,c),i.C.set(c.constructorFunction,c),c}Y.prototype.upgrade=function(i){bt(this.h,i)};function Tn(i){if(i.i!==!1){i.i=!1;for(var a=[],c=i.v,h=new Map,u=0;u<c.length;u++)h.set(c[u],[]);for(bt(i.h,document,{upgrade:function(b){if(b.__CE_state===void 0){var S=b.localName,I=h.get(S);I?I.push(b):i.u.has(S)&&a.push(b)}}}),u=0;u<a.length;u++)ve(i.h,a[u]);for(u=0;u<c.length;u++){for(var d=c[u],m=h.get(d),w=0;w<m.length;w++)ve(i.h,m[w]);(d=i.B.get(d))&&d.resolve(void 0)}c.length=0}}Y.prototype.get=function(i){if(i=me(this,i))return i.constructorFunction},Y.prototype.whenDefined=function(i){if(!wn(i))return Promise.reject(new SyntaxError("'"+i+"' is not a valid custom element name."));var a=this.B.get(i);if(a)return a.F;a=new En,this.B.set(i,a);var c=this.u.has(i)||this.s.has(i);return i=this.v.indexOf(i)===-1,c&&i&&a.resolve(void 0),a.F},Y.prototype.polyfillWrapFlushCallback=function(i){this.D&&Cn(this.D);var a=this.o;this.o=function(c){return i(function(){return a(c)})}};function me(i,a){var c=i.u.get(a);if(c)return c;if(c=i.s.get(a)){i.s.delete(a);try{return xn(i,a,c())}catch(h){Ht(h)}}}Y.prototype.define=Y.prototype.define,Y.prototype.upgrade=Y.prototype.upgrade,Y.prototype.get=Y.prototype.get,Y.prototype.whenDefined=Y.prototype.whenDefined,Y.prototype.polyfillDefineLazy=Y.prototype.H,Y.prototype.polyfillWrapFlushCallback=Y.prototype.polyfillWrapFlushCallback;function He(i,a,c){function h(u){return function(d){for(var m=[],w=0;w<arguments.length;++w)m[w]=arguments[w];w=[];for(var b=[],S=0;S<m.length;S++){var I=m[S];if(I instanceof Element&&B(I)&&b.push(I),I instanceof DocumentFragment)for(I=I.firstChild;I;I=I.nextSibling)w.push(I);else w.push(I)}for(u.apply(this,m),m=0;m<b.length;m++)ot(i,b[m]);if(B(this))for(m=0;m<w.length;m++)b=w[m],b instanceof Element&&pt(i,b)}}c.prepend!==void 0&&(a.prepend=h(c.prepend)),c.append!==void 0&&(a.append=h(c.append))}function Hr(i){Document.prototype.createElement=function(a){return bn(i,this,a,null)},Document.prototype.importNode=function(a,c){return a=n.call(this,a,!!c),this.__CE_registry?bt(i,a):Fe(i,a),a},Document.prototype.createElementNS=function(a,c){return bn(i,this,c,a)},He(i,Document.prototype,{prepend:r,append:o})}function Pr(i){function a(h){return function(u){for(var d=[],m=0;m<arguments.length;++m)d[m]=arguments[m];m=[];for(var w=[],b=0;b<d.length;b++){var S=d[b];if(S instanceof Element&&B(S)&&w.push(S),S instanceof DocumentFragment)for(S=S.firstChild;S;S=S.nextSibling)m.push(S);else m.push(S)}for(h.apply(this,d),d=0;d<w.length;d++)ot(i,w[d]);if(B(this))for(d=0;d<m.length;d++)w=m[d],w instanceof Element&&pt(i,w)}}var c=Element.prototype;M!==void 0&&(c.before=a(M)),W!==void 0&&(c.after=a(W)),Q!==void 0&&(c.replaceWith=function(h){for(var u=[],d=0;d<arguments.length;++d)u[d]=arguments[d];d=[];for(var m=[],w=0;w<u.length;w++){var b=u[w];if(b instanceof Element&&B(b)&&m.push(b),b instanceof DocumentFragment)for(b=b.firstChild;b;b=b.nextSibling)d.push(b);else d.push(b)}for(w=B(this),Q.apply(this,u),u=0;u<m.length;u++)ot(i,m[u]);if(w)for(ot(i,this),u=0;u<d.length;u++)m=d[u],m instanceof Element&&pt(i,m)}),nt!==void 0&&(c.remove=function(){var h=B(this);nt.call(this),h&&ot(i,this)})}function Ir(i){function a(u,d){Object.defineProperty(u,"innerHTML",{enumerable:d.enumerable,configurable:!0,get:d.get,set:function(m){var w=this,b=void 0;if(B(this)&&(b=[],Zt(i,this,function(Pt){Pt!==w&&b.push(Pt)})),d.set.call(this,m),b)for(var S=0;S<b.length;S++){var I=b[S];I.__CE_state===1&&i.disconnectedCallback(I)}return this.ownerDocument.__CE_registry?bt(i,this):Fe(i,this),m}})}function c(u,d){u.insertAdjacentElement=function(m,w){var b=B(w);return m=d.call(this,m,w),b&&ot(i,w),B(m)&&pt(i,w),m}}function h(u,d){function m(w,b){for(var S=[];w!==b;w=w.nextSibling)S.push(w);for(b=0;b<S.length;b++)bt(i,S[b])}u.insertAdjacentHTML=function(w,b){if(w=w.toLowerCase(),w==="beforebegin"){var S=this.previousSibling;d.call(this,w,b),m(S||this.parentNode.firstChild,this)}else if(w==="afterbegin")S=this.firstChild,d.call(this,w,b),m(this.firstChild,S);else if(w==="beforeend")S=this.lastChild,d.call(this,w,b),m(S||this.firstChild,null);else if(w==="afterend")S=this.nextSibling,d.call(this,w,b),m(this.nextSibling,S);else throw new SyntaxError("The value provided ("+String(w)+") is not one of 'beforebegin', 'afterbegin', 'beforeend', or 'afterend'.")}}_&&(Element.prototype.attachShadow=function(u){if(u=_.call(this,u),i.j&&!u.__CE_patched){u.__CE_patched=!0;for(var d=0;d<i.m.length;d++)i.m[d](u)}return this.__CE_shadowRoot=u}),k&&k.get?a(Element.prototype,k):it&&it.get?a(HTMLElement.prototype,it):Fr(i,function(u){a(u,{enumerable:!0,configurable:!0,get:function(){return f.call(this,!0).innerHTML},set:function(d){var m=this.localName==="template",w=m?this.content:this,b=e.call(document,this.namespaceURI,this.localName);for(b.innerHTML=d;0<w.childNodes.length;)g.call(w,w.childNodes[0]);for(d=m?b.content:b;0<d.childNodes.length;)v.call(w,d.childNodes[0])}})}),Element.prototype.setAttribute=function(u,d){if(this.__CE_state!==1)return A.call(this,u,d);var m=x.call(this,u);A.call(this,u,d),d=x.call(this,u),i.attributeChangedCallback(this,u,m,d,null)},Element.prototype.setAttributeNS=function(u,d,m){if(this.__CE_state!==1)return L.call(this,u,d,m);var w=C.call(this,u,d);L.call(this,u,d,m),m=C.call(this,u,d),i.attributeChangedCallback(this,d,w,m,u)},Element.prototype.removeAttribute=function(u){if(this.__CE_state!==1)return j.call(this,u);var d=x.call(this,u);j.call(this,u),d!==null&&i.attributeChangedCallback(this,u,d,null,null)},$&&(Element.prototype.toggleAttribute=function(u,d){if(this.__CE_state!==1)return $.call(this,u,d);var m=x.call(this,u),w=m!==null;return d=$.call(this,u,d),w!==d&&i.attributeChangedCallback(this,u,m,d?"":null,null),d}),Element.prototype.removeAttributeNS=function(u,d){if(this.__CE_state!==1)return $t.call(this,u,d);var m=C.call(this,u,d);$t.call(this,u,d);var w=C.call(this,u,d);m!==w&&i.attributeChangedCallback(this,d,m,w,u)},ht?c(HTMLElement.prototype,ht):D&&c(Element.prototype,D),Gt?h(HTMLElement.prototype,Gt):N&&h(Element.prototype,N),He(i,Element.prototype,{prepend:J,append:O}),Pr(i)}var Sn={};function qr(i){function a(){var c=this.constructor,h=document.__CE_registry.C.get(c);if(!h)throw Error("Failed to construct a custom element: The constructor was not registered with `customElements`.");var u=h.constructionStack;if(u.length===0)return u=t.call(document,h.localName),Object.setPrototypeOf(u,c.prototype),u.__CE_state=1,u.__CE_definition=h,Ft(i,u),u;var d=u.length-1,m=u[d];if(m===Sn)throw Error("Failed to construct '"+h.localName+"': This element was already constructed.");return u[d]=Sn,Object.setPrototypeOf(m,c.prototype),Ft(i,m),m}a.prototype=rt.prototype,Object.defineProperty(HTMLElement.prototype,"constructor",{writable:!0,configurable:!0,enumerable:!1,value:a}),window.HTMLElement=a}function Br(i){function a(c,h){Object.defineProperty(c,"textContent",{enumerable:h.enumerable,configurable:!0,get:h.get,set:function(u){if(this.nodeType===Node.TEXT_NODE)h.set.call(this,u);else{var d=void 0;if(this.firstChild){var m=this.childNodes,w=m.length;if(0<w&&B(this)){d=Array(w);for(var b=0;b<w;b++)d[b]=m[b]}}if(h.set.call(this,u),d)for(u=0;u<d.length;u++)ot(i,d[u])}}})}Node.prototype.insertBefore=function(c,h){if(c instanceof DocumentFragment){var u=je(c);if(c=p.call(this,c,h),B(this))for(h=0;h<u.length;h++)pt(i,u[h]);return c}return u=c instanceof Element&&B(c),h=p.call(this,c,h),u&&ot(i,c),B(this)&&pt(i,c),h},Node.prototype.appendChild=function(c){if(c instanceof DocumentFragment){var h=je(c);if(c=v.call(this,c),B(this))for(var u=0;u<h.length;u++)pt(i,h[u]);return c}return h=c instanceof Element&&B(c),u=v.call(this,c),h&&ot(i,c),B(this)&&pt(i,c),u},Node.prototype.cloneNode=function(c){return c=f.call(this,!!c),this.ownerDocument.__CE_registry?bt(i,c):Fe(i,c),c},Node.prototype.removeChild=function(c){var h=c instanceof Element&&B(c),u=g.call(this,c);return h&&ot(i,c),u},Node.prototype.replaceChild=function(c,h){if(c instanceof DocumentFragment){var u=je(c);if(c=y.call(this,c,h),B(this))for(ot(i,h),h=0;h<u.length;h++)pt(i,u[h]);return c}u=c instanceof Element&&B(c);var d=y.call(this,c,h),m=B(this);return m&&ot(i,h),u&&ot(i,c),m&&pt(i,c),d},E&&E.get?a(Node.prototype,E):Rr(i,function(c){a(c,{enumerable:!0,configurable:!0,get:function(){for(var h=[],u=this.firstChild;u;u=u.nextSibling)u.nodeType!==Node.COMMENT_NODE&&h.push(u.textContent);return h.join("")},set:function(h){for(;this.firstChild;)g.call(this,this.firstChild);h!=null&&h!==""&&v.call(this,document.createTextNode(h))}})})}var vt=window.customElements;function Nn(){var i=new pe;qr(i),Hr(i),He(i,DocumentFragment.prototype,{prepend:s,append:l}),Br(i),Ir(i),window.CustomElementRegistry=Y,i=new Y(i),document.__CE_registry=i,Object.defineProperty(window,"customElements",{configurable:!0,enumerable:!0,value:i})}vt&&!vt.forcePolyfill&&typeof vt.define=="function"&&typeof vt.get=="function"||Nn(),window.__CE_installPolyfill=Nn}).call(self);const en=1,nn=2,Un=4,Yr=8,zr=16,Ur=2,Xr=1,Jr=2,Xn="[",rn="[!",on="]",re={},Qt=Symbol();function sn(t){console.warn("hydration_mismatch")}let F=!1;function Ct(t){F=t}let P;function _t(t){if(t===null)throw sn(),re;return P=t}function ae(){return _t(P.nextSibling)}function z(t){if(F){if(P.nextSibling!==null)throw sn(),re;P=t}}function Kr(){F&&ae()}function Ye(){for(var t=0,e=P;;){if(e.nodeType===8){var n=e.data;if(n===on){if(t===0)return e;t-=1}else(n===Xn||n===rn)&&(t+=1)}var r=e.nextSibling;e.remove(),e=r}}const Mt=2,Jn=4,Yt=8,Kn=16,yt=32,ln=64,Rt=128,ye=256,dt=512,St=1024,zt=2048,jt=4096,Ut=8192,Gr=16384,an=32768,Zr=1<<18,Z=Symbol("$state"),Qr=Symbol("");var un=Array.isArray,to=Array.from,we=Object.keys,eo=Object.isFrozen,ie=Object.defineProperty,be=Object.getOwnPropertyDescriptor,no=Object.prototype,ro=Array.prototype,oo=Object.getPrototypeOf;function Gn(t){for(var e=0;e<t.length;e++)t[e]()}const io=typeof requestIdleCallback>"u"?t=>setTimeout(t,1):requestIdleCallback;let Ee=!1,ke=!1,ze=[],Ue=[];function Zn(){Ee=!1;const t=ze.slice();ze=[],Gn(t)}function Qn(){ke=!1;const t=Ue.slice();Ue=[],Gn(t)}function Ot(t){Ee||(Ee=!0,queueMicrotask(Zn)),ze.push(t)}function so(t){ke||(ke=!0,io(Qn)),Ue.push(t)}function lo(){Ee&&Zn(),ke&&Qn()}function tr(t){return t===this.v}function ao(t,e){return t!=t?e==e:t!==e||t!==null&&typeof t=="object"||typeof t=="function"}function uo(t){return!ao(t,this.v)}function co(t){throw new Error("effect_in_teardown")}function fo(){throw new Error("effect_in_unowned_derived")}function ho(t){throw new Error("effect_orphan")}function po(){throw new Error("effect_update_depth_exceeded")}function vo(){throw new Error("hydration_failed")}function mo(t){throw new Error("props_invalid_value")}function go(){throw new Error("state_unsafe_mutation")}function et(t){return{f:0,v:t,reactions:null,equals:tr,version:0}}function cn(t){var n;const e=et(t);return e.equals=uo,X!==null&&X.l!==null&&((n=X.l).s??(n.s=[])).push(e),e}function q(t,e){return V!==null&&Xe()&&V.f&Mt&&go(),t.equals(e)||(t.v=e,t.version=sr(),er(t,St),Xe()&&H!==null&&H.f&dt&&!(H.f&yt)&&(U!==null&&U.includes(t)?(at(H,St),Ae(H)):Tt===null?bo([t]):Tt.push(t))),e}function er(t,e){var n=t.reactions;if(n!==null){var r=Xe();for(var o of n){var s=o.f;s&St||!r&&o===H||(at(o,e),s&(dt|Rt)&&(s&Mt?er(o,zt):Ae(o)))}}}function _o(t){let e=Mt|St;H===null&&(e|=Rt);const n={deps:null,deriveds:null,equals:tr,f:e,first:null,fn:t,last:null,reactions:null,v:null,version:0};if(V!==null&&V.f&Mt){var r=V;r.deriveds===null?r.deriveds=[n]:r.deriveds.push(n)}return n}function nr(t){dn(t);var e=t.deriveds;if(e!==null){t.deriveds=null;for(var n=0;n<e.length;n+=1)yo(e[n])}}function rr(t){var e;nr(t),e=lr(t);var n=(qt||t.f&Rt)&&t.deps!==null?zt:dt;at(t,n),t.equals(e)||(t.v=e,t.version=sr())}function yo(t){nr(t),Se(t,0),at(t,Ut),t.first=t.last=t.deps=t.reactions=t.fn=null}const or=0,wo=1;let ge=or,se=!1,Bt=!1,fn=!1;function Ln(t){Bt=t}function Mn(t){fn=t}let Dt=[],Vt=0,V=null;function jn(t){V=t}let H=null,U=null,K=0,Tt=null;function bo(t){Tt=t}let ir=0,qt=!1,X=null;function sr(){return ir++}function Xe(){return X!==null&&X.l===null}function ue(t){var l,f;var e=t.f;if(e&St)return!0;if(e&zt){var n=t.deps,r=(e&Rt)!==0;if(n!==null){var o;if(e&ye){for(o=0;o<n.length;o++)((l=n[o]).reactions??(l.reactions=new Set)).add(t);t.f^=ye}for(o=0;o<n.length;o++){var s=n[o];if(ue(s)&&rr(s),s.version>t.version)return!0;r&&!qt&&!((f=s==null?void 0:s.reactions)!=null&&f.has(t))&&(s.reactions??(s.reactions=new Set)).add(t)}}r||at(t,dt)}return!1}function Eo(t,e,n){throw t}function lr(t){var E;var e=U,n=K,r=Tt,o=V,s=qt;U=null,K=0,Tt=null,V=t.f&(yt|ln)?null:t,qt=!Bt&&(t.f&Rt)!==0;try{var l=(0,t.fn)(),f=t.deps;if(U!==null){var v,p;if(f!==null){var g=K===0?U:f.slice(0,K).concat(U),y=g.length>16?new Set(g):null;for(p=K;p<f.length;p++)v=f[p],(y!==null?!y.has(v):!g.includes(v))&&ar(t,v)}if(f!==null&&K>0)for(f.length=K+U.length,p=0;p<U.length;p++)f[K+p]=U[p];else t.deps=f=U;if(!qt)for(p=K;p<f.length;p++)((E=f[p]).reactions??(E.reactions=new Set)).add(t)}else f!==null&&K<f.length&&(Se(t,K),f.length=K);return l}finally{U=e,K=n,Tt=r,V=o,qt=s}}function ar(t,e){let n=e.reactions;n!==null&&(n.delete(t),n.size===0&&(n=e.reactions=null)),n===null&&e.f&Mt&&(at(e,zt),e.f&(Rt|ye)||(e.f^=ye),Se(e,0))}function Se(t,e){var n=t.deps;if(n!==null)for(var r=e===0?null:n.slice(0,e),o=new Set,s=e;s<n.length;s++){var l=n[s];o.has(l)||(o.add(l),(r===null||!r.includes(l))&&ar(t,l))}}function dn(t,e=!1){var n=t.first;for(t.first=t.last=null;n!==null;){var r=n.next;Kt(n,e),n=r}}function Ne(t){var e=t.f;if(!(e&Ut)){at(t,dt);var n=t.ctx,r=H,o=X;H=t,X=n;try{e&Kn||dn(t),mr(t);var s=lr(t);t.teardown=typeof s=="function"?s:null,t.version=ir}catch(l){Eo(l)}finally{H=r,X=o}}}function ur(){Vt>1e3&&(Vt=0,po()),Vt++}function cr(t){var e=t.length;if(e!==0){ur();var n=Bt;Bt=!0;try{for(var r=0;r<e;r++){var o=t[r];if(o.first===null&&!(o.f&yt))On([o]);else{var s=[];fr(o,s),On(s)}}}finally{Bt=n}}}function On(t){var e=t.length;if(e!==0)for(var n=0;n<e;n++){var r=t[n];!(r.f&(Ut|jt))&&ue(r)&&(Ne(r),r.deps===null&&r.first===null&&r.nodes===null&&(r.teardown===null?gr(r):r.fn=null))}}function ko(){if(se=!1,Vt>1001)return;const t=Dt;Dt=[],cr(t),se||(Vt=0)}function Ae(t){ge===or&&(se||(se=!0,queueMicrotask(ko)));for(var e=t;e.parent!==null;){e=e.parent;var n=e.f;if(n&yt){if(!(n&dt))return;at(e,zt)}}Dt.push(e)}function fr(t,e){var n=t.first,r=[];t:for(;n!==null;){var o=n.f,s=(o&(Ut|jt))===0,l=o&yt,f=(o&dt)!==0,v=n.first;if(s&&(!l||!f)){if(l&&at(n,dt),o&Yt){if(!l&&ue(n)&&(Ne(n),v=n.first),v!==null){n=v;continue}}else if(o&Jn)if(l||f){if(v!==null){n=v;continue}}else r.push(n)}var p=n.next;if(p===null){let E=n.parent;for(;E!==null;){if(t===E)break t;var g=E.next;if(g!==null){n=g;continue t}E=E.parent}}n=p}for(var y=0;y<r.length;y++)v=r[y],e.push(v),fr(v,e)}function Xt(t){var e=ge,n=Dt;try{ur();const o=[];ge=wo,Dt=o,se=!1,cr(n);var r=t==null?void 0:t();return lo(),(Dt.length>0||o.length>0)&&Xt(),Vt=0,r}finally{ge=e,Dt=n}}function T(t){var e=t.f;if(e&Ut)return t.v;if(V!==null){var n=V.deps;U===null&&n!==null&&n[K]===t?K++:(n===null||K===0||n[K-1]!==t)&&(U===null?U=[t]:U[U.length-1]!==t&&U.push(t)),Tt!==null&&H!==null&&H.f&dt&&!(H.f&yt)&&Tt.includes(t)&&(at(H,St),Ae(H))}if(e&Mt){var r=t;ue(r)&&rr(r)}return t.v}function dr(t){const e=V;try{return V=null,t()}finally{V=e}}const Co=~(St|zt|dt);function at(t,e){t.f=t.f&Co|e}function ce(t,e=!1,n){X={p:X,c:null,e:null,m:!1,s:t,x:null,l:null},e||(X.l={s:null,u:null,r1:[],r2:et(!1)})}function fe(t){const e=X;if(e!==null){t!==void 0&&(e.x=t);const r=e.e;if(r!==null){e.e=null;for(var n=0;n<r.length;n++)hn(r[n])}X=e.p,e.m=!0}return t||{}}function $o(t){H===null&&V===null&&ho(),V!==null&&V.f&Rt&&fo(),fn&&co()}function Rn(t,e){var n=e.last;n===null?e.last=e.first=t:(n.next=t,t.prev=n,e.last=t)}function Jt(t,e,n,r=!0){var o=(t&ln)!==0,s=H,l={ctx:X,deps:null,nodes:null,f:t|St,first:null,fn:e,last:null,next:null,parent:o?null:s,prev:null,teardown:null,transitions:null,version:0};if(n){var f=Bt;try{Ln(!0),Ne(l),l.f|=Gr}catch(p){throw Kt(l),p}finally{Ln(f)}}else e!==null&&Ae(l);var v=n&&l.deps===null&&l.first===null&&l.nodes===null&&l.teardown===null;return!v&&!o&&r&&(s!==null&&Rn(l,s),V!==null&&V.f&Mt&&Rn(l,V)),l}function hr(t){const e=Jt(Yt,null,!1);return at(e,dt),e.teardown=t,e}function Je(t){$o();var e=H!==null&&(H.f&Yt)!==0&&X!==null&&!X.m;if(e){var n=X;(n.e??(n.e=[])).push(t)}else{var r=hn(t);return r}}function pr(t){const e=Jt(ln,t,!0);return()=>{Kt(e)}}function hn(t){return Jt(Jn,t,!1)}function de(t){return Jt(Yt,t,!0)}function gt(t){return de(t)}function vr(t,e=0){return Jt(Yt|Kn|e,t,!0)}function le(t,e=!0){return Jt(Yt|yt,t,!0,e)}function mr(t){var e=t.teardown;if(e!==null){const n=fn,r=V;Mn(!0),jn(null);try{e.call(null)}finally{Mn(n),jn(r)}}}function Kt(t,e=!0){var n=!1;if((e||t.f&Zr)&&t.nodes!==null){for(var r=t.nodes.start,o=t.nodes.end;r!==null;){var s=r===o?null:r.nextSibling;r.remove(),r=s}n=!0}if(dn(t,e&&!n),Se(t,0),at(t,Ut),t.transitions)for(const f of t.transitions)f.stop();mr(t);var l=t.parent;l!==null&&t.f&yt&&l.first!==null&&gr(t),t.next=t.prev=t.teardown=t.ctx=t.deps=t.parent=t.fn=t.nodes=null}function gr(t){var e=t.parent,n=t.prev,r=t.next;n!==null&&(n.next=r),r!==null&&(r.prev=n),e!==null&&(e.first===t&&(e.first=r),e.last===t&&(e.last=n))}function Ke(t,e){var n=[];pn(t,n,!0),_r(n,()=>{Kt(t),e&&e()})}function _r(t,e){var n=t.length;if(n>0){var r=()=>--n||e();for(var o of t)o.out(r)}else e()}function pn(t,e,n){if(!(t.f&jt)){if(t.f^=jt,t.transitions!==null)for(const l of t.transitions)(l.is_global||n)&&e.push(l);for(var r=t.first;r!==null;){var o=r.next,s=(r.f&an)!==0||(r.f&yt)!==0;pn(r,e,s?n:!1),r=o}}}function Ce(t){yr(t,!0)}function yr(t,e){if(t.f&jt){t.f^=jt,ue(t)&&Ne(t);for(var n=t.first;n!==null;){var r=n.next,o=(n.f&an)!==0||(n.f&yt)!==0;yr(n,o?e:!1),n=r}if(t.transitions!==null)for(const s of t.transitions)(s.is_global||e)&&s.in()}}function ct(t,e=null,n){if(typeof t=="object"&&t!=null&&!eo(t)){if(Z in t){const o=t[Z];if(o.t===t||o.p===t)return o.p}const r=oo(t);if(r===no||r===ro){const o=new Proxy(t,xo);return ie(t,Z,{value:{s:new Map,v:et(0),a:un(t),p:o,t},writable:!0,enumerable:!1}),o}}return t}function Fn(t,e=1){q(t,t.v+e)}const xo={defineProperty(t,e,n){if(n.value){const r=t[Z],o=r.s.get(e);o!==void 0&&q(o,ct(n.value,r))}return Reflect.defineProperty(t,e,n)},deleteProperty(t,e){const n=t[Z],r=n.s.get(e),o=n.a,s=delete t[e];if(o&&s){const l=n.s.get("length"),f=t.length-1;l!==void 0&&l.v!==f&&q(l,f)}return r!==void 0&&q(r,Qt),s&&Fn(n.v),s},get(t,e,n){var s;if(e===Z)return Reflect.get(t,Z);const r=t[Z];let o=r.s.get(e);if(o===void 0&&(!(e in t)||(s=be(t,e))!=null&&s.writable)&&(o=et(ct(t[e],r)),r.s.set(e,o)),o!==void 0){const l=T(o);return l===Qt?void 0:l}return Reflect.get(t,e,n)},getOwnPropertyDescriptor(t,e){const n=Reflect.getOwnPropertyDescriptor(t,e);if(n&&"value"in n){const o=t[Z].s.get(e);o&&(n.value=T(o))}return n},has(t,e){var s;if(e===Z)return!0;const n=t[Z],r=Reflect.has(t,e);let o=n.s.get(e);return(o!==void 0||H!==null&&(!r||(s=be(t,e))!=null&&s.writable))&&(o===void 0&&(o=et(r?ct(t[e],n):Qt),n.s.set(e,o)),T(o)===Qt)?!1:r},set(t,e,n,r){const o=t[Z];let s=o.s.get(e);s===void 0&&(dr(()=>r[e]),s=o.s.get(e)),s!==void 0&&q(s,ct(n,o));const l=o.a,f=!(e in t);if(l&&e==="length")for(let p=n;p<t.length;p+=1){const g=o.s.get(p+"");g!==void 0&&q(g,Qt)}var v=Reflect.getOwnPropertyDescriptor(t,e);if(v!=null&&v.set?v.set.call(r,n):t[e]=n,f){if(l){const p=o.s.get("length"),g=t.length;p!==void 0&&p.v!==g&&q(p,g)}Fn(o.v)}return!0},ownKeys(t){const e=t[Z];return T(e.v),Reflect.ownKeys(t)}};function $e(t){if(t!==null&&typeof t=="object"&&Z in t){var e=t[Z];if(e)return e.p}return t}function To(t,e){return Object.is($e(t),$e(e))}var xe,At;function wr(){if(xe===void 0){xe=window,At=document;var t=Element.prototype;t.__click=void 0,t.__className="",t.__attributes=null,t.__e=void 0,Text.prototype.__t=void 0}}function he(){return document.createTextNode("")}function G(t){if(!F)return t.firstChild;var e=P.firstChild;return e===null&&(e=P.appendChild(he())),_t(e),e}function vn(t,e){if(!F){var n=t.firstChild;return n instanceof Comment&&n.data===""?n.nextSibling:n}return P}function R(t,e=!1){if(!F)return t.nextSibling;var n=P.nextSibling,r=n.nodeType;if(e&&r!==3){var o=he();return n==null||n.before(o),_t(o),o}return _t(n),n}function mn(t){t.textContent=""}const br=new Set,Ge=new Set;function So(t,e,n,r){function o(s){if(r.capture||ee.call(e,s),!s.cancelBubble)return n.call(this,s)}return t.startsWith("pointer")||t.startsWith("touch")||t==="wheel"?Ot(()=>{e.addEventListener(t,o,r)}):e.addEventListener(t,o,r),o}function mt(t,e,n,r,o){var s={capture:r,passive:o},l=So(t,e,n,s);(e===document.body||e===window||e===document)&&hr(()=>{e.removeEventListener(t,l,s)})}function Er(t){for(var e=0;e<t.length;e++)br.add(t[e]);for(var n of Ge)n(t)}function ee(t){var A;var e=this,n=e.ownerDocument,r=t.type,o=((A=t.composedPath)==null?void 0:A.call(t))||[],s=o[0]||t.target,l=0,f=t.__root;if(f){var v=o.indexOf(f);if(v!==-1&&(e===document||e===window)){t.__root=e;return}var p=o.indexOf(e);if(p===-1)return;v<=p&&(l=v)}if(s=o[l]||t.target,s!==e){ie(t,"currentTarget",{configurable:!0,get(){return s||n}});try{for(var g,y=[];s!==null;){var E=s.parentNode||s.host||null;try{var _=s["__"+r];if(_!==void 0&&!s.disabled)if(un(_)){var[k,...x]=_;k.apply(s,[t,...x])}else _.call(s,t)}catch(j){g?y.push(j):g=j}if(t.cancelBubble||E===e||E===null)break;s=E}if(g){for(let j of y)queueMicrotask(()=>{throw j});throw g}}finally{t.__root=e,s=e}}}function No(t){var e=document.createElement("template");return e.innerHTML=t,e.content}function Wt(t,e){H.nodes??(H.nodes={start:t,end:e})}function wt(t,e){var n=(e&Xr)!==0,r=(e&Jr)!==0,o,s=!t.startsWith("<!>");return()=>{if(F)return Wt(P,null),P;o||(o=No(s?t:"<!>"+t),n||(o=o.firstChild));var l=r?document.importNode(o,!0):o.cloneNode(!0);if(n){var f=l.firstChild,v=l.lastChild;Wt(f,v)}else Wt(l,l);return l}}function Ao(){if(F)return Wt(P,null),P;var t=document.createDocumentFragment(),e=document.createComment(""),n=he();return t.append(e,n),Wt(e,n),t}function lt(t,e){if(F){H.nodes.end=P,ae();return}t!==null&&t.before(e)}const Do=["wheel","touchstart","touchmove","touchend","touchcancel"];function Lo(t){return Do.includes(t)}function qe(t,e){(t.__t??(t.__t=t.nodeValue))!==e&&(t.__t=e,t.nodeValue=e==null?"":e+"")}function kr(t,e){const n=e.anchor??e.target.appendChild(he());return Cr(t,{...e,anchor:n})}function Mo(t,e){e.intro=e.intro??!1;const n=e.target,r=F,o=P;try{for(var s=n.firstChild;s&&(s.nodeType!==8||s.data!==Xn);)s=s.nextSibling;if(!s)throw re;Ct(!0),_t(s),ae();const l=Cr(t,{...e,anchor:s});if(P===null||P.nodeType!==8||P.data!==on)throw sn(),re;return Ct(!1),l}catch(l){if(l===re)return e.recover===!1&&vo(),wr(),mn(n),Ct(!1),kr(t,e);throw l}finally{Ct(r),_t(o)}}const It=new Map;function Cr(t,{target:e,anchor:n,props:r={},events:o,context:s,intro:l=!0}){wr();var f=new Set,v=y=>{for(var E=0;E<y.length;E++){var _=y[E];if(!f.has(_)){f.add(_);var k=Lo(_);e.addEventListener(_,ee,{passive:k});var x=It.get(_);x===void 0?(document.addEventListener(_,ee,{passive:k}),It.set(_,1)):It.set(_,x+1)}}};v(to(br)),Ge.add(v);var p=void 0,g=pr(()=>(le(()=>{if(s){ce({});var y=X;y.c=s}o&&(r.$$events=o),F&&Wt(n,null),p=t(n,r)||{},F&&(H.nodes.end=P),s&&fe()}),()=>{for(var y of f){e.removeEventListener(y,ee);var E=It.get(y);--E===0?(document.removeEventListener(y,ee),It.delete(y)):It.set(y,E)}Ge.delete(v),Ze.delete(p)}));return Ze.set(p,g),p}let Ze=new WeakMap;function jo(t){const e=Ze.get(t);e==null||e()}function Te(t,e,n,r=null,o=!1){F&&ae();var s=t,l=null,f=null,v=null,p=o?an:0;vr(()=>{if(v===(v=!!e()))return;let g=!1;if(F){const y=s.data===rn;v===y&&(s=Ye(),_t(s),Ct(!1),g=!0)}v?(l?Ce(l):l=le(()=>n(s)),f&&Ke(f,()=>{f=null})):(f?Ce(f):r&&(f=le(()=>r(s))),l&&Ke(l,()=>{l=null})),g&&Ct(!0)},p),F&&(s=P)}let Be=null;function Oo(t,e){return e}function Ro(t,e,n,r){for(var o=[],s=e.length,l=0;l<s;l++)pn(e[l].e,o,!0);var f=s>0&&o.length===0&&n!==null;if(f){var v=n.parentNode;mn(v),v.append(n),r.clear(),xt(t,e[0].prev,e[s-1].next)}_r(o,()=>{for(var p=0;p<s;p++){var g=e[p];f||(r.delete(g.k),xt(t,g.prev,g.next)),Kt(g.e,!f)}})}function gn(t,e,n,r,o,s=null){var l=t,f={flags:e,items:new Map,first:null},v=(e&Un)!==0;if(v){var p=t;l=F?_t(p.firstChild):p.appendChild(he())}F&&ae();var g=null;vr(()=>{var y=n(),E=un(y)?y:y==null?[]:Array.from(y),_=E.length;let k=!1;if(F){var x=l.data===rn;x!==(_===0)&&(l=Ye(),_t(l),Ct(!1),k=!0)}if(F){for(var A=null,j,$=0;$<_;$++){if(P.nodeType===8&&P.data===on){l=P,k=!0,Ct(!1);break}var C=E[$],L=r(C,$);j=$r(P,f,A,null,C,L,$,o,e),f.items.set(L,j),A=j}_>0&&_t(Ye())}F||Fo(E,f,l,o,e,r),s!==null&&(_===0?g?Ce(g):g=le(()=>s(l)):g!==null&&Ke(g,()=>{g=null})),k&&Ct(!0)}),F&&(l=P)}function Fo(t,e,n,r,o,s){var nt,rt,it,ht;var l=(o&Yr)!==0,f=(o&(en|nn))!==0,v=t.length,p=e.items,g=e.first,y=g,E=new Set,_=null,k=new Set,x=[],A=[],j,$,C,L;if(l)for(L=0;L<v;L+=1)j=t[L],$=s(j,L),C=p.get($),C!==void 0&&((nt=C.a)==null||nt.measure(),k.add(C));for(L=0;L<v;L+=1){if(j=t[L],$=s(j,L),C=p.get($),C===void 0){var $t=y?y.e.nodes.start:n;_=$r($t,e,_,_===null?e.first:_.next,j,$,L,r,o),p.set($,_),x=[],A=[],y=_.next;continue}if(f&&Ho(C,j,L,o),C.e.f&jt&&(Ce(C.e),l&&((rt=C.a)==null||rt.unfix(),k.delete(C))),C!==y){if(E.has(C)){if(x.length<A.length){var D=A[0],N;_=D.prev;var J=x[0],O=x[x.length-1];for(N=0;N<x.length;N+=1)Hn(x[N],D,n);for(N=0;N<A.length;N+=1)E.delete(A[N]);xt(e,J.prev,O.next),xt(e,_,J),xt(e,O,D),y=D,_=O,L-=1,x=[],A=[]}else E.delete(C),Hn(C,y,n),xt(e,C.prev,C.next),xt(e,C,_===null?e.first:_.next),xt(e,_,C),_=C;continue}for(x=[],A=[];y!==null&&y.k!==$;)E.add(y),A.push(y),y=y.next;if(y===null)continue;C=y}x.push(C),_=C,y=C.next}const M=Array.from(E);for(;y!==null;)M.push(y),y=y.next;var W=M.length;if(W>0){var Q=o&Un&&v===0?n:null;if(l){for(L=0;L<W;L+=1)(it=M[L].a)==null||it.measure();for(L=0;L<W;L+=1)(ht=M[L].a)==null||ht.fix()}Ro(e,M,Q,p)}l&&Ot(()=>{var Gt;for(C of k)(Gt=C.a)==null||Gt.apply()}),H.first=e.first&&e.first.e,H.last=_&&_.e}function Ho(t,e,n,r){r&en&&q(t.v,e),r&nn?q(t.i,n):t.i=n}function $r(t,e,n,r,o,s,l,f,v){var p=Be;try{var g=(v&en)!==0,y=(v&zr)===0,E=g?y?cn(o):et(o):o,_=v&nn?et(l):l,k={i:_,v:E,k:s,a:null,e:null,prev:n,next:r};return Be=k,k.e=le(()=>f(t,E,_),F),k.e.prev=n&&n.e,k.e.next=r&&r.e,n===null?e.first=k:(n.next=k,n.e.next=k.e),r!==null&&(r.prev=k,r.e.prev=k.e),k}finally{Be=p}}function Hn(t,e,n){for(var r=t.next?t.next.e.nodes.start:n,o=e?e.e.nodes.start:n,s=t.e.nodes.start;s!==r;){var l=s.nextSibling;o.before(s),s=l}}function xt(t,e,n){e===null?t.first=n:(e.next=n,e.e.next=n&&n.e),n!==null&&(n.prev=e,n.e.prev=e&&e.e)}var Pn=new Set;function _n(t,e,n=!1){if(!n){if(Pn.has(e))return;Pn.add(e)}Ot(()=>{var r=t.getRootNode(),o=r.host?r:r.head??r.ownerDocument.head;if(!o.querySelector("#"+e.hash)){const s=document.createElement("style");s.id=e.hash,s.textContent=e.code,o.appendChild(s)}})}function Po(t,e){{const n=document.body;t.autofocus=!0,Ot(()=>{document.activeElement===n&&t.focus()})}}function Io(t){F&&t.firstChild!==null&&mn(t)}let In=!1;function xr(){In||(In=!0,document.addEventListener("reset",t=>{Promise.resolve().then(()=>{var e;if(!t.defaultPrevented)for(const n of t.target.elements)(e=n.__on_r)==null||e.call(n)})},{capture:!0}))}function qo(t){if(F){var e=!1,n=()=>{if(!e){if(e=!0,t.hasAttribute("value")){var r=t.value;ft(t,"value",null),t.value=r}if(t.hasAttribute("checked")){var o=t.checked;ft(t,"checked",null),t.checked=o}}};t.__on_r=n,so(n),xr()}}function Bo(t,e){var n=t.__attributes??(t.__attributes={});n.value!==(n.value=e)&&(t.value=e)}function ft(t,e,n,r){n=n==null?null:n+"";var o=t.__attributes??(t.__attributes={});F&&(o[e]=t.getAttribute(e),e==="src"||e==="href"||e==="srcset")||o[e]!==(o[e]=n)&&(e==="loading"&&(t[Qr]=n),n===null?t.removeAttribute(e):t.setAttribute(e,n))}function oe(t,e,n){if(n){if(t.classList.contains(e))return;t.classList.add(e)}else{if(!t.classList.contains(e))return;t.classList.remove(e)}}function Tr(t,e,n,r=n){t.addEventListener(e,n);const o=t.__on_r;o?t.__on_r=()=>{o(),r()}:t.__on_r=r,xr()}function Vo(t,e,n){Tr(t,"input",()=>{n(Bn(t)?Vn(t.value):t.value)}),de(()=>{var r=e();if(F&&t.defaultValue!==t.value){n(t.value);return}Bn(t)&&r===Vn(t.value)||t.type==="date"&&!r&&!t.value||(t.value=r??"")})}const Ve=new Set;function Wo(t,e,n,r,o){var s=n.getAttribute("type")==="checkbox",l=t;let f=!1;if(e!==null)for(var v of e)l=l[v]??(l[v]=[]);l.push(n),Tr(n,"change",()=>{var p=n.__value;s&&(p=qn(l,p,n.checked)),o(p)},()=>o(s?[]:null)),de(()=>{var p=r();if(F&&n.defaultChecked!==n.checked){f=!0;return}s?(p=p||[],n.checked=$e(p).includes($e(n.__value))):n.checked=To(n.__value,p)}),hr(()=>{var p=l.indexOf(n);p!==-1&&l.splice(p,1)}),Ve.has(l)||(Ve.add(l),Ot(()=>{l.sort((p,g)=>p.compareDocumentPosition(g)===4?-1:1),Ve.delete(l)})),Ot(()=>{if(f){var p;if(s)p=qn(l,p,n.checked);else{var g=l.find(y=>y.checked);p=g==null?void 0:g.__value}o(p)}})}function qn(t,e,n){for(var r=new Set,o=0;o<t.length;o+=1)t[o].checked&&r.add(t[o].__value);return n||r.delete(e),Array.from(r)}function Bn(t){var e=t.type;return e==="number"||e==="range"}function Vn(t){return t===""?null:+t}function Wn(t,e){var r;var n=t&&((r=t[Z])==null?void 0:r.t);return t===e||n===e}function Qe(t={},e,n,r){return hn(()=>{var o,s;return de(()=>{o=s,s=[],dr(()=>{t!==n(...s)&&(e(t,...s),o&&Wn(n(...o),t)&&e(null,...o))})}),()=>{Ot(()=>{s&&Wn(n(...s),t)&&e(null,...s)})}}),t}function De(t,e,n,r){var k;var o=(n&Ur)!==0,s=t[e],l=(k=be(t,e))==null?void 0:k.set,f=r,v=()=>f;s===void 0&&r!==void 0&&(l&&o&&mo(),s=v(),l&&l(s));var p;if(p=()=>{var x=t[e];return x===void 0?v():x},l){var g=t.$$legacy;return function(x,A){return arguments.length>0?((!A||g)&&l(A?p():x),x):p()}}var y=!1,E=cn(s),_=_o(()=>{var x=p(),A=T(E);return y?(y=!1,A):E.v=x});return function(x,A){var j=T(_);if(arguments.length>0){const $=A?T(_):x;return _.equals($)||(y=!0,q(E,$),T(_)),x}return j}}function Yo(t){return new zo(t)}var Et,st;class zo{constructor(e){Pe(this,Et);Pe(this,st);var s;var n=new Map,r=(l,f)=>{var v=cn(f);return n.set(l,v),v};const o=new Proxy({...e.props||{},$$events:{}},{get(l,f){return T(n.get(f)??r(f,Reflect.get(l,f)))},has(l,f){return T(n.get(f)??r(f,Reflect.get(l,f))),Reflect.has(l,f)},set(l,f,v){return q(n.get(f)??r(f,v),v),Reflect.set(l,f,v)}});Ie(this,st,(e.hydrate?Mo:kr)(e.component,{target:e.target,props:o,context:e.context,intro:e.intro??!1,recover:e.recover})),(s=e==null?void 0:e.props)!=null&&s.$$host||Xt(),Ie(this,Et,o.$$events);for(const l of Object.keys(tt(this,st)))l==="$set"||l==="$destroy"||l==="$on"||ie(this,l,{get(){return tt(this,st)[l]},set(f){tt(this,st)[l]=f},enumerable:!0});tt(this,st).$set=l=>{Object.assign(o,l)},tt(this,st).$destroy=()=>{jo(tt(this,st))}}$set(e){tt(this,st).$set(e)}$on(e,n){tt(this,Et)[e]=tt(this,Et)[e]||[];const r=(...o)=>n.call(this,...o);return tt(this,Et)[e].push(r),()=>{tt(this,Et)[e]=tt(this,Et)[e].filter(o=>o!==r)}}$destroy(){tt(this,st).$destroy()}}Et=new WeakMap,st=new WeakMap;let Sr;typeof HTMLElement=="function"&&(Sr=class extends HTMLElement{constructor(e,n,r){super();ut(this,"$$ctor");ut(this,"$$s");ut(this,"$$c");ut(this,"$$cn",!1);ut(this,"$$d",{});ut(this,"$$r",!1);ut(this,"$$p_d",{});ut(this,"$$l",{});ut(this,"$$l_u",new Map);ut(this,"$$me");this.$$ctor=e,this.$$s=n,r&&this.attachShadow({mode:"open"})}addEventListener(e,n,r){if(this.$$l[e]=this.$$l[e]||[],this.$$l[e].push(n),this.$$c){const o=this.$$c.$on(e,n);this.$$l_u.set(n,o)}super.addEventListener(e,n,r)}removeEventListener(e,n,r){if(super.removeEventListener(e,n,r),this.$$c){const o=this.$$l_u.get(n);o&&(o(),this.$$l_u.delete(n))}}async connectedCallback(){if(this.$$cn=!0,!this.$$c){let e=function(o){return s=>{const l=document.createElement("slot");o!=="default"&&(l.name=o),lt(s,l)}};if(await Promise.resolve(),!this.$$cn||this.$$c)return;const n={},r=Uo(this);for(const o of this.$$s)o in r&&(o==="default"&&!this.$$d.children?(this.$$d.children=e(o),n.default=!0):n[o]=e(o));for(const o of this.attributes){const s=this.$$g_p(o.name);s in this.$$d||(this.$$d[s]=_e(s,o.value,this.$$p_d,"toProp"))}for(const o in this.$$p_d)!(o in this.$$d)&&this[o]!==void 0&&(this.$$d[o]=this[o],delete this[o]);this.$$c=Yo({component:this.$$ctor,target:this.shadowRoot||this,props:{...this.$$d,$$slots:n,$$host:this}}),this.$$me=de(()=>{var o;this.$$r=!0;for(const s of we(this.$$c)){if(!((o=this.$$p_d[s])!=null&&o.reflect))continue;this.$$d[s]=this.$$c[s];const l=_e(s,this.$$d[s],this.$$p_d,"toAttribute");l==null?this.removeAttribute(this.$$p_d[s].attribute||s):this.setAttribute(this.$$p_d[s].attribute||s,l)}this.$$r=!1});for(const o in this.$$l)for(const s of this.$$l[o]){const l=this.$$c.$on(o,s);this.$$l_u.set(s,l)}this.$$l={}}}attributeChangedCallback(e,n,r){var o;this.$$r||(e=this.$$g_p(e),this.$$d[e]=_e(e,r,this.$$p_d,"toProp"),(o=this.$$c)==null||o.$set({[e]:this.$$d[e]}))}disconnectedCallback(){this.$$cn=!1,Promise.resolve().then(()=>{!this.$$cn&&this.$$c&&(this.$$c.$destroy(),Kt(this.$$me),this.$$c=void 0)})}$$g_p(e){return we(this.$$p_d).find(n=>this.$$p_d[n].attribute===e||!this.$$p_d[n].attribute&&n.toLowerCase()===e)||e}});function _e(t,e,n,r){var s;const o=(s=n[t])==null?void 0:s.type;if(e=o==="Boolean"&&typeof e!="boolean"?e!=null:e,!r||!n[t])return e;if(r==="toAttribute")switch(o){case"Object":case"Array":return e==null?null:JSON.stringify(e);case"Boolean":return e?"":null;case"Number":return e??null;default:return e}else switch(o){case"Object":case"Array":return e&&JSON.parse(e);case"Boolean":return e;case"Number":return e!=null?+e:e;default:return e}}function Uo(t){const e={};return t.childNodes.forEach(n=>{e[n.slot||"default"]=!0}),e}function Le(t,e,n,r,o,s){let l=class extends Sr{constructor(){super(t,n,o),this.$$p_d=e}static get observedAttributes(){return we(e).map(f=>(e[f].attribute||f).toLowerCase())}};return we(e).forEach(f=>{ie(l.prototype,f,{get(){return this.$$c&&f in this.$$c?this.$$c[f]:this.$$d[f]},set(v){var y;v=_e(f,v,e),this.$$d[f]=v;var p=this.$$c;if(p){var g=(y=be(p,f))==null?void 0:y.get;g?p[f]=v:p.$set({[f]:v})}}})}),r.forEach(f=>{ie(l.prototype,f,{get(){var v;return(v=this.$$c)==null?void 0:v[f]}})}),t.element=l,l}const Nt=new Map([["yellow","#F8B920"],["red","#FF4646"],["blue","#0064FF"],["green","#00C564"]]),Xo=["SCRIPT","STYLE","NOSCRIPT","TEXTAREA","OPTION"];function Nr(t){const e=document.documentElement.lang||void 0,n=t.map(f=>f.trim().toLocaleLowerCase(e)),r=n.map(()=>({start:null,end:null,shift:0})),o=n.map(()=>[]),s=document.createTreeWalker(document.body,NodeFilter.SHOW_TEXT,f=>{var v,p;return Xo.includes((v=f.parentNode)==null?void 0:v.tagName)||((p=f.parentNode)==null?void 0:p.contentEditable)=="true"?NodeFilter.FILTER_REJECT:NodeFilter.FILTER_ACCEPT});let l;for(;l=s.nextNode();)if(l!=null&&l.nodeValue)for(let f=0;f<l.nodeValue.length;f++){const v=l.nodeValue[f].toLocaleLowerCase(e).trim();v&&n.forEach((p,g)=>{var E;for(;p[r[g].shift]&&!p[r[g].shift].trim();)r[g].shift++;let y=p[r[g].shift]===v;if(!y&&r[g].shift&&(r[g].shift=0,y=p[r[g].shift]===v),y&&(r[g].shift||(r[g].start=[l,f]),r[g].end=[l,f],r[g].shift++),r[g].shift>=p.length){const _=document.createRange();_.setStart(r[g].start[0],r[g].start[1]),_.setEnd(r[g].end[0],r[g].end[1]+1),!_.collapsed&&((E=_.commonAncestorContainer.parentElement)!=null&&E.checkVisibility())?o[g].push(_):_.detach(),y=!1}y||(r[g].shift=0,r[g].start=null,r[g].end=null)})}return o}const Lt=`rh-${new Date().getTime()}-`,Me="highlights"in CSS;function Jo(t){if(!t.length&&!CSS.highlights.size)return;const e=[];if(CSS.highlights.clear(),t.length){const r=Nr(t.map(({text:o})=>o||""));for(const o in t){if(!r[o].length)continue;const{_id:s,color:l,note:f}=t[o],v=`${Lt}${s}`;CSS.highlights.set(v,new Highlight(...r[o]));const p=r[o][0].getBoundingClientRect();e.push(`
                ::highlight(${v}) {
                    all: unset;
                    background-color: color-mix(in srgb, ${Nt.get(l)||l||"yellow"}, white 60%) !important;
                    color: color-mix(in srgb, ${Nt.get(l)||l||"yellow"}, black 80%) !important;
                    ${f?"text-decoration: underline wavy; -webkit-text-decoration: underline wavy;":""}
                    text-decoration-thickness: from-font;
                }

                /* fuck you dark reader */
                html[data-darkreader-scheme="dark"] ::highlight(${v}) {
                    color: CanvasText !important;
                }

                :root {
                    --highlight-${s}-top: ${(100/document.documentElement.scrollHeight*(window.scrollY+p.top-10)).toFixed(2)}%;
                }
            `);for(const g of r[o])g.detach()}}const n=(()=>{let r=document.getElementById(Lt);return r||(r=document.createElement("style"),r.id=Lt,document.head.appendChild(r)),r})();n.innerHTML=e.join(`
`)}function Ko(){var t;(t=document.getElementById(Lt))==null||t.remove()}function Go(t){var e;for(const[n,r]of CSS.highlights){const o=n.replace(Lt,"");if(t==o)for(const s of r){(e=s.startContainer.parentElement)==null||e.scrollIntoView({behavior:"smooth",block:"start"});break}}}function Zo(t){let e;for(const[n,r]of CSS.highlights)for(const o of r){const s=t.compareBoundaryPoints(Range.START_TO_START,o),l=t.compareBoundaryPoints(Range.END_TO_END,o);(s==0&&l==0||t!=null&&t.collapsed&&s>=0&&l<=0)&&(e=[n.replace(Lt,""),o])}if(e)return e[0].replace(Lt,"")}const kt=`rh-${new Date().getTime()}`;function Qo(t){const e=document.body.querySelectorAll(`.${kt}`);if(!t.length&&!e.length)return;e.forEach(s=>s.outerHTML=s.innerText);const n=[],r=Nr(t.map(({text:s})=>s||""));for(const s in t){const{_id:l,color:f}=t[s];for(const v of r[s]){const p=document.createElement("mark");p.className=kt,p.setAttribute("data-id",String(l)),p.append(v.extractContents()),v.insertNode(p),v.detach()}n.push(`
            .${kt}[data-id="${l}"] {
                all: unset;
                display: inline-block !important;
                background-color: white !important;
                background-image: linear-gradient(to bottom, ${Yn(Nt.get(f)||f,.4)} 0, ${Yn(Nt.get(f)||f,.4)} 100%) !important;
                color: black !important;
            }
        `)}const o=(()=>{let s=document.getElementById(kt);return s||(s=document.createElement("style"),s.id=kt,document.head.appendChild(s)),s})();o.innerHTML=n.join(`
`)}function ti(){var t;document.body.querySelectorAll(`.${kt}`).forEach(e=>e.outerHTML=e.innerText),(t=document.getElementById(kt))==null||t.remove()}function ei(t){const e=document.body.querySelector(`.${kt}[data-id="${t}"]`);e&&e.scrollIntoView({behavior:"smooth",block:"start"})}function ni(t){const e=t.commonAncestorContainer.nodeType==Node.ELEMENT_NODE?t.commonAncestorContainer:t.commonAncestorContainer.parentElement;if((e==null?void 0:e.className)==kt){if(!t.collapsed){const n=new Range;n.selectNodeContents(t.commonAncestorContainer);const r=t.compareBoundaryPoints(Range.START_TO_START,n),o=t.compareBoundaryPoints(Range.END_TO_END,n);if(n.detach(),r!=0||o!=0)return}return e.getAttribute("data-id")||void 0}}function Yn(t,e){if(!t)return t;const n=parseInt(t.slice(1,3),16),r=parseInt(t.slice(3,5),16),o=parseInt(t.slice(5,7),16);return`rgba(${n}, ${r}, ${o}, ${e})`}function ri(t){return Me?Jo(t):Qo(t)}function We(t){return ri(t)}function oi(){return Me?Ko():ti()}function Ar(t){return Me?Go(t):ei(t)}function Dr(){var n,r,o;const t=document.getSelection();if(!(t!=null&&t.rangeCount))return;const e=t.getRangeAt(0);if(!((o=((n=e==null?void 0:e.commonAncestorContainer)==null?void 0:n.nodeType)==1?e==null?void 0:e.commonAncestorContainer:(r=e==null?void 0:e.commonAncestorContainer)==null?void 0:r.parentElement)!=null&&o.closest('[contenteditable=""], [contenteditable=true]')))return e}function ne(){const t=document.getSelection();t!=null&&t.rangeCount&&t.removeAllRanges()}function ii(t){return Me?Zo(t):ni(t)}function zn(t){if(!t)return"";var e=document.createElement("div");e.appendChild(t.cloneContents().cloneNode(!0)),document.body.appendChild(e);const n=e.innerText;return document.body.removeChild(e),e=void 0,n}function si(t,e,n){let r=et(ct([])),o=et(!1),s=et(!1),l=et(void 0);function f(_){const k=ii(_);if(k)return T(r).find(A=>A._id==k);if(zn(_).trim())return{text:zn(_).trim()}}function v(_){const k={...typeof _._id=="string"?{_id:_._id}:{},...typeof _.text=="string"?{text:_.text}:{},...typeof _.note=="string"?{note:_.note}:{},color:_.color||"yellow"};if(!k.text)return;const x=T(r).findIndex(A=>{var j,$;return A._id==k._id||((j=A.text)==null?void 0:j.toLocaleLowerCase().trim())===(($=k.text)==null?void 0:$.toLocaleLowerCase().trim())});x!=-1?(T(r)[x]=k,e(k)):(T(r).push(k),t(k))}function p({_id:_}){q(r,ct(T(r).filter(k=>k._id!=_))),n({_id:_})}function g(_){q(l,ct(JSON.parse(JSON.stringify(_))))}function y(){T(l)&&(v(T(l)),q(l,void 0))}function E(){q(l,void 0)}return{get highlights(){return T(r)},set highlights(_){q(r,ct(_))},get pro(){return T(o)},set pro(_){q(o,ct(_))},get nav(){return T(s)},set nav(_){q(s,ct(_))},get draft(){return T(l)},find:f,upsert:v,remove:p,setDraft:g,draftSubmit:y,draftCancel:E}}const li="5";typeof window<"u"&&(window.__svelte||(window.__svelte={v:new Set})).v.add(li);function ai(t,e){let n=null,r=!0;return function(...s){n||(r?(t(...s),r=!1):(clearTimeout(n),n=setTimeout(()=>{t(...s),clearTimeout(n),n=null},e)))}}function tn(){var t;return(t=navigator==null?void 0:navigator.userAgentData)!=null&&t.mobile?!0:/Android|webOS|iPhone|iPad|iPod|Opera Mini/i.test(navigator.userAgent)}var ui=wt('<button type="submit" class="svelte-f9ok5r"><span class="color svelte-f9ok5r"></span></button>'),ci=wt('<button type="submit" value="remove" title="Delete highlight" class="svelte-f9ok5r"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 18 18" class="svelte-f9ok5r"><g class="svelte-f9ok5r"><line x1="2.75" y1="4.25" x2="15.25" y2="4.25" fill="none" stroke-linecap="round" stroke-linejoin="round" class="svelte-f9ok5r"></line><path d="M6.75,4.25v-1.5c0-.552,.448-1,1-1h2.5c.552,0,1,.448,1,1v1.5" fill="none" stroke-linecap="round" stroke-linejoin="round" class="svelte-f9ok5r"></path><path d="M13.5,6.75l-.4,7.605c-.056,1.062-.934,1.895-1.997,1.895H6.898c-1.064,0-1.941-.833-1.997-1.895l-.4-7.605" fill="none" stroke-linecap="round" stroke-linejoin="round" class="svelte-f9ok5r"></path></g></svg></button>'),fi=wt('<dialog class="svelte-f9ok5r"><form method="dialog" class="svelte-f9ok5r"><!> <button type="submit" value="note" title="Add note" class="svelte-f9ok5r"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 18 18" class="svelte-f9ok5r"><g class="svelte-f9ok5r"><path stroke-linecap="round" stroke-linejoin="round" d="M9,1.75C4.996,1.75,1.75,4.996,1.75,9c0,1.319,.358,2.552,.973,3.617,.43,.806-.053,2.712-.973,3.633,1.25,.068,2.897-.497,3.633-.973,.489,.282,1.264,.656,2.279,.848,.433,.082,.881,.125,1.338,.125,4.004,0,7.25-3.246,7.25-7.25S13.004,1.75,9,1.75Z" class="svelte-f9ok5r"></path><path stroke-width="0" d="M9,10c-.552,0-1-.449-1-1s.448-1,1-1,1,.449,1,1-.448,1-1,1Z" class="svelte-f9ok5r"></path><path stroke-width="0" d="M5.5,10c-.552,0-1-.449-1-1s.448-1,1-1,1,.449,1,1-.448,1-1,1Z" class="svelte-f9ok5r"></path><path stroke-width="0" d="M12.5,10c-.552,0-1-.449-1-1s.448-1,1-1,1,.449,1,1-.448,1-1,1Z" class="svelte-f9ok5r"></path></g></svg></button> <!></form></dialog>');const di={hash:"svelte-f9ok5r",code:`
    .svelte-f9ok5r {
        user-select: none;
        -webkit-user-select: none;
        box-sizing: border-box;
        -webkit-tap-highlight-color: transparent;
    }

    dialog.svelte-f9ok5r {
        --control-size: 16px;
        --padding-s: 6px;
        --padding-m: 8px;

        --bg-light: rgb(255, 255, 255);
        --bg-dark: rgb(60, 60, 60);
        --control-fg-light: rgb(65, 65, 65);
        --control-fg-dark: rgb(230, 230, 230);
        --hover-bg-light: rgba(0,0,0,.07);
        --hover-bg-dark: rgba(255,255,255,.1);
        --active-bg-light: rgba(0,0,0,.13);
        --active-bg-dark: rgba(255,255,255,.2);
    }

    @supports (background-color: -apple-system-control-background) {
        dialog.svelte-f9ok5r {
            --bg-light: rgba(255, 255, 255, .8);
            --bg-dark: rgba(60, 60, 60, .8);
            backdrop-filter: blur(5px);
            -webkit-backdrop-filter: blur(5px);
        }
    }

    dialog.mobile.svelte-f9ok5r {
        --control-size: 26px;
    }

    dialog.svelte-f9ok5r {
        position: absolute;
        left: unset;
        top: unset;
        right: unset;
        bottom: unset;
        border: none;
        padding: 2px;
        border-radius: var(--control-size);
        overflow: clip;
        z-index: 999999999999999;

        background: var(--bg-light);
        color: var(--control-fg-light);

        @supports(color: light-dark(white,black)) {
            background: light-dark(var(--bg-light), var(--bg-dark));
            color: light-dark(var(--control-fg-light), var(--control-fg-dark));
        }
    }    

    dialog.mobile.new.svelte-f9ok5r {
        position: fixed;
        top: auto !important;
        left: auto !important;
        right: 16px !important;
        bottom: 16px !important;
        margin-right: env(safe-area-inset-right);
        margin-bottom: env(safe-area-inset-bottom);
    }

    [open].svelte-f9ok5r {
        box-shadow: 0 0 0 .5px rgba(0,0,0,.2), 0 5px 10px rgba(0,0,0,.05), 0 15px 40px rgba(0,0,0,.1);
    }

    form.svelte-f9ok5r {
        display: flex;
        gap: 2px;
        margin: 0;
        padding: 0;
    }

    button.svelte-f9ok5r {
        border-radius: var(--control-size);
        border: 0;
        background: transparent;
        cursor: pointer;
        appearance: none;
        touch-action: manipulation;
        width: calc(var(--control-size) + var(--padding-s)*2);
        height: calc(var(--control-size) + var(--padding-s)*2);
        padding: var(--padding-s);
        color: inherit;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: background .15s ease-in-out;
    }

    @media (pointer: fine) {
        button.svelte-f9ok5r:hover {
            transition: none;
            background: var(--hover-bg-light);

            @supports(color: light-dark(white,black)) {
                background: light-dark(var(--hover-bg-light), var(--hover-bg-dark));
            }
        }
    }

    button.svelte-f9ok5r:active {
        transition: none;
        background: var(--active-bg-light);

        @supports(color: light-dark(white,black)) {
            background: light-dark(var(--active-bg-light), var(--active-bg-dark));
        }
    }

    svg.svelte-f9ok5r {
        stroke: currentColor;
        stroke-width: 1.5px;
    }

    .color.svelte-f9ok5r {
        pointer-events: none;
        content: '';
        display: block;
        width: 15px;
        height: 15px;
        background: var(--color);
        transition: background .15s ease-in-out, box-shadow .15s ease-in-out;
        border-radius: 50%;
    }

    .color.active.svelte-f9ok5r {
        background: transparent;
        box-shadow: inset 0 0 0 5px var(--color);
    }

    /* animation */
    dialog.svelte-f9ok5r {
        transition: 
            display .25s allow-discrete ease-in-out, 
            overlay .25s allow-discrete ease-in-out, 
            box-shadow .25s allow-discrete ease-in-out, 
            opacity .25s ease-in-out,
            left .15s ease-in-out,
            top .15s ease-in-out,
            right .15s ease-in-out,
            bottom .15s ease-in-out;
        opacity: 0;
    }

    [open].svelte-f9ok5r {
        opacity: 1;
    }

    dialog.svelte-f9ok5r:not([open]) {
        transition-duration: .2s;
        pointer-events: none;
    }

    @starting-style {
        [open].svelte-f9ok5r {
            opacity: 0;
        }
    }
`};function Lr(t,e){ce(e,!0),_n(t,di,!0);let n=De(e,"store",7),r,o=et(void 0),s=et(!1);function l(D){if(!T(o))return;const N=D.currentTarget.returnValue;switch(D.currentTarget.returnValue="",N){case"add":n().upsert(T(o)),ne();break;case"note":n().setDraft(T(o)),ne();break;case"remove":n().remove(T(o)),ne();break;default:if(Nt.has(N)){n().upsert({...T(o),color:N}),ne();return}break}}function f(){q(s,!0)}function v(){q(s,!1),setTimeout(p)}function p(){if(T(s)){r==null||r.close();return}requestAnimationFrame(()=>{const D=Dr(),N=D&&n().find(D);if(!D||!(N!=null&&N._id)&&!D.toString().trim()){r==null||r.close();return}q(o,ct(N)),r.inert=!0,r==null||r.show(),r.inert=!1;const J=256,O=10,M=D.getBoundingClientRect(),W=Math.min(Math.max(M.x,O)+window.scrollX,window.innerWidth+window.scrollX-J-O),Q=Math.min(window.innerWidth-Math.max(M.x,O)-window.scrollX-M.width,window.innerWidth-window.scrollX-J-O),nt=Math.max(M.y,40)+window.scrollY+M.height+4,rt=window.innerHeight-Math.max(M.y,40)-window.scrollY+4,it=W<window.innerWidth/2+window.scrollX,ht=nt<window.innerHeight/2+window.scrollY;r==null||r.style.setProperty("left",it?`${W}px`:"unset"),r==null||r.style.setProperty("right",it?"unset":`${Q}px`),r==null||r.style.setProperty("top",ht?`${nt}px`:"unset"),r==null||r.style.setProperty("bottom",ht?"unset":`${rt}px`)})}const g=ai(p,200);var y=fi();mt("mousedown",At,f),mt("touchstart",At,f,void 0,!0),mt("mouseup",At,v),mt("touchend",At,v,void 0,!0),mt("touchcancel",At,v,void 0,!0),mt("selectionchange",At,g),Qe(y,D=>r=D,()=>r),gt(()=>oe(y,"mobile",tn()));var E=G(y),_=G(E);gn(_,17,()=>Nt,([D,N],J)=>D,(D,N,J)=>{let O=()=>T(N)[0],M=()=>T(N)[1];var W=ui(),Q=G(W);z(W),gt(()=>{var nt;Bo(W,O()),ft(Q,"style",`--color: ${M()??""}`),oe(Q,"active",O()==((nt=T(o))==null?void 0:nt.color))}),lt(D,W)});var k=R(R(_,!0)),x=G(k),A=G(x),j=G(A),$=R(j),C=R($),L=R(C);z(A),z(x),z(k);var $t=R(R(k,!0));return Te($t,()=>{var D;return(D=T(o))==null?void 0:D._id},D=>{var N=ci(),J=G(N),O=G(J),M=G(O),W=R(M);R(W),z(O),z(J),z(N),lt(D,N)}),z(E),z(y),gt(()=>{var D,N,J,O,M,W;oe(y,"new",!((D=T(o))!=null&&D._id)),ft(j,"fill",(N=T(o))!=null&&N.note?"currentColor":"none"),ft(j,"stroke-width",(J=T(o))!=null&&J.note?"0":void 0),ft($,"fill",(O=T(o))!=null&&O.note?"none":"currentColor"),ft(C,"fill",(M=T(o))!=null&&M.note?"none":"currentColor"),ft(L,"fill",(W=T(o))!=null&&W.note?"none":"currentColor")}),mt("close",y,l),lt(t,y),fe({get store(){return n()},set store(D){n(D),Xt()}})}Le(Lr,{store:{}},[],[],!0);function hi(t){const e=t.currentTarget.getBoundingClientRect();e.top<=t.clientY&&t.clientY<=e.top+e.height&&e.left<=t.clientX&&t.clientX<=e.left+e.width||(t.preventDefault(),t.currentTarget.close())}var pi=(t,e)=>q(e,!1),vi=wt('<input type="radio" name="color" class="svelte-n7j6yt">'),mi=wt('<div class="unlock svelte-n7j6yt"><a href="https://raindrop.io/pro/buy" target="_blank" class="svelte-n7j6yt">Upgrade to Pro</a> to unlock annotation</div>'),gi=wt('<blockquote role="presentation" class="svelte-n7j6yt"> </blockquote> <fieldset class="color svelte-n7j6yt"></fieldset> <textarea class="note svelte-n7j6yt" rows="4" maxlength="5000" placeholder="Notes (optional)"></textarea> <!>',1),_i=wt('<dialog role="presentation" class="svelte-n7j6yt"><header class="svelte-n7j6yt"> </header> <form method="dialog" class="svelte-n7j6yt"><!> <footer class="svelte-n7j6yt"><button formnovalidate="" class="svelte-n7j6yt">Cancel <sup class="svelte-n7j6yt">esc</sup></button> <button type="submit" value="OK" class="svelte-n7j6yt"> <sup class="svelte-n7j6yt">&crarr;</sup></button></footer></form></dialog>');const yi={hash:"svelte-n7j6yt",code:`
    .svelte-n7j6yt {
        box-sizing: border-box;
        -webkit-tap-highlight-color: transparent;
    }

    dialog.svelte-n7j6yt {
        --bg-light: rgb(245, 245, 245);
        --bg-dark: rgb(35, 35, 35);
        --fg-light: black;
        --fg-dark: white;
        --control-bg-light: rgb(230, 230, 230);
        --control-bg-dark: rgb(55, 55, 55);

        font-family: -apple-system, BlinkMacSystemFont, Segoe UI, Helvetica, Arial, sans-serif, Apple Color Emoji, Segoe UI Emoji;
        font-size: 18px;
        line-height: 1.4;
        border: none;
        border-radius: .5em;
        padding: 0;
        overscroll-behavior: none;

        color: var(--fg-light);

        @supports(color: light-dark(white,black)) {
            color: light-dark(var(--fg-light), var(--fg-dark));
        }
    }

    dialog.mobile.svelte-n7j6yt {
        left: 0;right: 0;bottom: 0;top: 0;
        width: 100%;
        margin: 0;
        max-width: 100%;
        max-height: 100%;
        border-radius: 0;
        bottom: auto;
    }

    dialog.svelte-n7j6yt, header.svelte-n7j6yt {
        background: var(--bg-light);

        @supports(color: light-dark(white,black)) {
            background: light-dark(var(--bg-light), var(--bg-dark));
        }
    }

    [open].svelte-n7j6yt {
        box-shadow: 0 0 0 .5px rgba(60, 60, 60, .9), 0 3px 10px rgba(0,0,0,.05), 0 7px 15px -3px rgba(0,0,0,.15);
    }

    .svelte-n7j6yt::backdrop {
        background-color: rgba(0,0,0,.3);
    }

    header.svelte-n7j6yt {
        margin: 0;
        padding: 1em;
        font-weight: bold;
        position: sticky;
        top: 0;
    }

    @supports(animation-timeline: scroll()) {
        header.svelte-n7j6yt {
            animation: svelte-n7j6yt-header-scroll linear both;
            animation-timeline: scroll();
            animation-range: 0 1px;
        }
    }

    @keyframes svelte-n7j6yt-header-scroll {
        to {
            box-shadow: 0 .5px 0 rgba(0,0,0,.2);
        }
    }

    form.svelte-n7j6yt {
        display: flex;
        flex-direction: column;
        gap: 1em;
        padding: 1em;
        padding-top: 0;
    }

    .color.svelte-n7j6yt {
        all: unset;
        display: flex;
        gap: .75em;
    }

    .color.svelte-n7j6yt input[type="radio"]:where(.svelte-n7j6yt) {
        cursor: pointer;
        appearance: none;
        user-select: none;
        -webkit-user-select: none;
        margin: 0;
        background: var(--color);
        transition: box-shadow .2s ease-in-out, background .2s ease-in-out;
        width: 2em;
        height: 2em;
        border-radius: 50%;
    }

    .color.svelte-n7j6yt input[type="radio"]:where(.svelte-n7j6yt):checked {
        background: transparent;
        box-shadow: inset 0 0 0 .5em var(--color);
    }

    .color.svelte-n7j6yt input[type="radio"]:where(.svelte-n7j6yt):active {
        transform: translateY(1px);
    }

    blockquote.svelte-n7j6yt, .note.svelte-n7j6yt, button.svelte-n7j6yt {
        background: var(--control-bg-light);

        @supports(color: light-dark(white,black)) {
            background: light-dark(var(--control-bg-light), var(--control-bg-dark));
        }
    }

    blockquote.svelte-n7j6yt {
        white-space: pre-wrap;
        margin: 0;
        min-width: 100%;
        width: 0;
        font-size: 16px;
    }

    blockquote.compact.svelte-n7j6yt {
        white-space: nowrap;
        text-overflow: ellipsis;
        overflow: hidden;
        overflow: clip;
    }

    blockquote.svelte-n7j6yt, .note.svelte-n7j6yt {
        border-radius: .5em;
        padding: .5em .6em;
    }

    .note.svelte-n7j6yt {
        min-width: min(21em, 70vw);
        min-height: 4lh;
        appearance: none;
        border: 0;
        font: inherit;
        color: inherit;
        display: block;
        scroll-margin-top: 100vh;
        transition: background .15s ease-in-out, box-shadow .15s ease-in-out;
    }

    .note.svelte-n7j6yt:focus {
        background: transparent;
    }
    
    footer.svelte-n7j6yt {
        all: unset;
        display: flex;
        justify-content: flex-end;
        gap: .75em;
    }

    button.svelte-n7j6yt {
        appearance: none;
        user-select: none;
        -webkit-user-select: none;
        touch-action: manipulation;
        border: 0;
        font: inherit;
        color: inherit;
        cursor: pointer;
        padding: .25em .75em;
        border-radius: .5em;
    }

    button.svelte-n7j6yt:active {
        transform: translateY(1px);
    }

    button.svelte-n7j6yt sup:where(.svelte-n7j6yt) {
        margin-left: .25em;
        vertical-align: text-top;
        opacity: .5;
    }

    dialog.mobile.svelte-n7j6yt button:where(.svelte-n7j6yt) sup:where(.svelte-n7j6yt) {
        display: none;
    }

    button[value].svelte-n7j6yt {
        background: blue;
        background: AccentColor;
        color: white;
    }

    .unlock.svelte-n7j6yt {
        font-size: .75em;
        color: GrayText;
    }

    /* animation */
    dialog.svelte-n7j6yt, .svelte-n7j6yt::backdrop {
        transition: 
            display .2s allow-discrete ease-in-out, 
            overlay .2s allow-discrete ease-in-out, 
            opacity .2s ease-in-out,
            transform .2s ease-in-out,
            box-shadow .2s ease-in-out;
        opacity: 0;
    }

    dialog.svelte-n7j6yt {
        transform: translateY(1em);
    }

    [open].svelte-n7j6yt,
    [open].svelte-n7j6yt::backdrop {
        opacity: 1;
        transform: translateY(0);
    }

    @starting-style {
        [open].svelte-n7j6yt,
        [open].svelte-n7j6yt::backdrop {
            opacity: 0;
        }

        [open].svelte-n7j6yt {
            transform: translateY(-1em);
        }
    }

    @supports not selector(::highlight(a)) {
        dialog.svelte-n7j6yt, dialog.svelte-n7j6yt::backdrop {
            animation: svelte-n7j6yt-simple-appear .2s forwards;
        }
        @keyframes svelte-n7j6yt-simple-appear {
            from { opacity: 0; }
            to { opacity: 1; }
        }
    }
`};function Mr(t,e){ce(e,!0),_n(t,yi,!0);const n=[];let r=De(e,"store",7),o,s,l=et(!0);Je(()=>{r().draft?(q(l,!0),o==null||o.showModal()):o==null||o.close()});function f($){const C=$.currentTarget.returnValue;$.currentTarget.returnValue="",setTimeout(C?r().draftSubmit:r().draftCancel,200)}function v($){var C;tn()||($.stopImmediatePropagation(),$.stopPropagation(),$.key=="Enter"&&!$.shiftKey&&($.preventDefault(),s&&((C=$.currentTarget.closest("form"))==null||C.requestSubmit(s))))}var p=_i();Qe(p,$=>o=$,()=>o),p.__mousedown=[hi],gt(()=>oe(p,"mobile",tn()));var g=G(p),y=G(g);z(g);var E=R(R(g,!0)),_=G(E);Te(_,()=>r().draft,$=>{var C=gi(),L=vn(C);L.__click=[pi,l];var $t=G(L);gt(()=>{var O,M;return qe($t,((M=(O=r().draft)==null?void 0:O.text)==null?void 0:M.trim())||"")}),z(L);var D=R(R(L,!0));gn(D,21,()=>Nt,Oo,(O,M,W)=>{let Q=()=>T(M)[0],nt=()=>T(M)[1];var rt=vi();qo(rt);var it;gt(()=>{it!==(it=Q())&&(rt.value=(rt.__value=Q())==null?"":Q()),ft(rt,"style",`--color: ${nt()??""}`)}),Wo(n,[],rt,()=>(Q(),r().draft.color),ht=>r().draft.color=ht),lt(O,rt)}),z(D);var N=R(R(D,!0));Io(N),Po(N),N.__keydown=v;var J=R(R(N,!0));Te(J,()=>!r().pro,O=>{var M=mi();G(M),Kr(),z(M),lt(O,M)}),gt(()=>{oe(L,"compact",T(l)),N.disabled=!r().pro}),Vo(N,()=>r().draft.note,O=>r().draft.note=O),lt($,C)});var k=R(R(_,!0)),x=G(k);R(G(x)),z(x);var A=R(R(x,!0));Qe(A,$=>s=$,()=>s);var j=G(A);return R(j),z(A),z(k),z(E),z(p),gt(()=>{var $,C;qe(y,`${(($=r().draft)!=null&&$._id?"Edit":"New")??""} highlight`),qe(j,`${((C=r().draft)!=null&&C._id?"Update":"Create")??""} `)}),mt("close",p,f),lt(t,p),fe({get store(){return r()},set store($){r($),Xt()}})}Er(["mousedown","click","keydown"]);Le(Mr,{store:{}},[],[],!0);const wi=t=>{const e=t.target.getAttribute("data-highlight");e&&(t.preventDefault(),Ar(e))};var bi=wt('<div class="svelte-rwfy02"></div>'),Ei=wt('<nav role="presentation" class="svelte-rwfy02"></nav>');const ki={hash:"svelte-rwfy02",code:`
    nav.svelte-rwfy02 {
        all: unset;
    }
    
    div.svelte-rwfy02 {
        position: fixed;
        right: 0;
        width: 24px;
        height: 20px;
        display: flex;
        justify-content: flex-end;
        align-items: center;
        cursor: pointer;
        background: transparent;
        z-index: 99999999999999;
    }

    div.svelte-rwfy02::before {
        content: '';
        display: block;
        height: 3px;
        border-radius: 3px;
        width: 16px;
        background: var(--color);
        transition: width .15s ease-in-out;
    }

    div.svelte-rwfy02:hover::before {
        width: 100%;
    }
`};function jr(t,e){ce(e,!0),_n(t,ki,!0);let n=De(e,"store",7);var r=Ao(),o=vn(r);return Te(o,()=>n().nav,s=>{var l=Ei();l.__click=[wi],gn(l,21,()=>n().highlights,(f,v)=>f._id,(f,v,p)=>{var g=bi();gt(()=>ft(g,"style",`top: var(--highlight-${T(v)._id??""}-top); --color: ${(Nt.get(T(v).color)||T(v).color)??""}`)),gt(()=>ft(g,"data-highlight",T(v)._id)),lt(f,g)}),z(l),lt(s,l)}),lt(t,r),fe({get store(){return n()},set store(s){n(s),Xt()}})}Er(["click"]);Le(jr,{store:{}},[],[],!0);var Ci=wt("<!> <!> <!>",1);function $i(t,e){ce(e,!0);let n=De(e,"store",7);Je(()=>{We(n().highlights)});let r;function o(){We(n().highlights),clearTimeout(r),r=setTimeout(()=>We(n().highlights),3e3)}pr(()=>{document.readyState&&o()}),Je(()=>oi);var s=Ci();mt("load",xe,o),mt("popstate",xe,o);var l=vn(s);Lr(l,{get store(){return n()}});var f=R(R(l,!0));Mr(f,{get store(){return n()}});var v=R(R(f,!0));return jr(v,{get store(){return n()}}),lt(t,s),fe({get store(){return n()},set store(p){n(p),Xt()}})}customElements.define("rdh-ui",Le($i,{store:{}},[],[],!0));function xi(t){if(typeof chrome=="object"&&chrome.runtime&&chrome.runtime.onMessage||typeof browser=="object"&&browser.runtime&&browser.runtime.onMessage){const{runtime:e}=typeof browser=="object"?browser:chrome,n=(r,o)=>{o.id==e.id&&typeof r.type=="string"&&t(r)};return e.onMessage.removeListener(n),e.onMessage.addListener(n),r=>e.sendMessage(null,r)}if(window.webkit&&window.webkit.messageHandlers&&window.webkit.messageHandlers.rdh)return window.rdhSend=t,e=>window.webkit.messageHandlers.rdh.postMessage(e);if(typeof window<"u"&&typeof window.process=="object"&&window.process.type==="renderer"||typeof process<"u"&&typeof process.versions=="object"&&process.versions.electron){const{ipcRenderer:e}=require("electron"),n=(r,o)=>t(o);return e.removeListener("RDH",n),e.on("RDH",n),r=>e.sendToHost("RDH",r)}if("ReactNativeWebView"in window)return window.ReactNativeWebViewSendMessage=t,e=>window.ReactNativeWebView.postMessage(JSON.stringify(e));if(window.self!==window.top){const e=({data:n,source:r})=>{r!==window.parent||typeof n!="object"||typeof n.type!="string"||t(n)};return window.removeEventListener("message",e),window.addEventListener("message",e),n=>window.parent.postMessage(n,"*")}throw new Error("unsupported platform")}async function Ti(t){let e=!1;const n=new Set,r=xi(o=>{if(!e){n.add(o);return}t(o)});await new Promise(o=>{function s(){window.removeEventListener("DOMContentLoaded",s),o()}document.readyState=="loading"?(window.removeEventListener("DOMContentLoaded",s),window.addEventListener("DOMContentLoaded",s,{once:!0})):o()}),e=!0;for(const o of n)t(o),n.delete(o);return r}const te=document.createElement("rdh-ui");(async()=>{const t=await Ti(n=>{switch(n.type){case"RDH_APPLY":Array.isArray(n.payload)&&(e.highlights=n.payload);break;case"RDH_CONFIG":typeof n.payload.pro=="boolean"&&(e.pro=n.payload.pro),typeof n.payload.nav=="boolean"&&(e.nav=n.payload.nav),typeof n.payload.enabled=="boolean"&&(n.payload.enabled===!0?document.body.contains(te)||document.body.appendChild(te):document.body.contains(te)&&document.body.removeChild(te));break;case"RDH_SCROLL":typeof n.payload._id=="string"&&Ar(n.payload._id);break;case"RDH_ADD_SELECTION":const r=Dr();if(!r)return;const o=e.find(r);if(!o)return;e.upsert(o),ne();break;case"RDH_NOTE_SELECTION":console.log("not implemented yet");break}}),e=si(n=>t({type:"RDH_ADD",payload:n}),n=>t({type:"RDH_UPDATE",payload:n}),({_id:n})=>t({type:"RDH_REMOVE",payload:{_id:n}}));te.store=e,t({type:"RDH_READY",payload:{url:location.href}})})();
