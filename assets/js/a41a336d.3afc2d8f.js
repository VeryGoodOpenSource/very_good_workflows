"use strict";(self.webpackChunkworkflows_docs=self.webpackChunkworkflows_docs||[]).push([[607],{3905:(e,t,n)=>{n.d(t,{Zo:()=>c,kt:()=>m});var r=n(7294);function o(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function a(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function i(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?a(Object(n),!0).forEach((function(t){o(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):a(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,r,o=function(e,t){if(null==e)return{};var n,r,o={},a=Object.keys(e);for(r=0;r<a.length;r++)n=a[r],t.indexOf(n)>=0||(o[n]=e[n]);return o}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(r=0;r<a.length;r++)n=a[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(o[n]=e[n])}return o}var p=r.createContext({}),s=function(e){var t=r.useContext(p),n=t;return e&&(n="function"==typeof e?e(t):i(i({},t),e)),n},c=function(e){var t=s(e.components);return r.createElement(p.Provider,{value:t},e.children)},d="mdxType",k={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},u=r.forwardRef((function(e,t){var n=e.components,o=e.mdxType,a=e.originalType,p=e.parentName,c=l(e,["components","mdxType","originalType","parentName"]),d=s(n),u=o,m=d["".concat(p,".").concat(u)]||d[u]||k[u]||a;return n?r.createElement(m,i(i({ref:t},c),{},{components:n})):r.createElement(m,i({ref:t},c))}));function m(e,t){var n=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var a=n.length,i=new Array(a);i[0]=u;var l={};for(var p in t)hasOwnProperty.call(t,p)&&(l[p]=t[p]);l.originalType=e,l[d]="string"==typeof e?e:o,i[1]=l;for(var s=2;s<a;s++)i[s]=n[s];return r.createElement.apply(null,i)}return r.createElement.apply(null,n)}u.displayName="MDXCreateElement"},9321:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>p,contentTitle:()=>i,default:()=>k,frontMatter:()=>a,metadata:()=>l,toc:()=>s});var r=n(7462),o=(n(7294),n(3905));const a={sidebar_position:5},i="License Check",l={unversionedId:"workflows/license_check",id:"workflows/license_check",title:"License Check",description:"At VGV, we keep track of the rights and restrictions external dependencies might impose on Dart or Flutter projects.",source:"@site/docs/workflows/license_check.md",sourceDirName:"workflows",slug:"/workflows/license_check",permalink:"/docs/workflows/license_check",draft:!1,editUrl:"https://github.com/VeryGoodOpenSource/very_good_workflows/tree/main/site/docs/workflows/license_check.md",tags:[],version:"current",sidebarPosition:5,frontMatter:{sidebar_position:5},sidebar:"tutorialSidebar",previous:{title:"Flutter Pub Publish",permalink:"/docs/workflows/flutter_pub_publish"},next:{title:"Mason Publish",permalink:"/docs/workflows/mason_publish"}},p={},s=[{value:"Steps",id:"steps",level:2},{value:"Inputs",id:"inputs",level:2},{value:"<code>working_directory</code>",id:"working_directory",level:3},{value:"<code>runs_on</code>",id:"runs_on",level:3},{value:"<code>dart_sdk</code>",id:"dart_sdk",level:3},{value:"<code>allowed</code>",id:"allowed",level:3},{value:"<code>forbidden</code>",id:"forbidden",level:3},{value:"<code>skip_packages</code>",id:"skip_packages",level:3},{value:"<code>dependency_type</code>",id:"dependency_type",level:3},{value:"<code>ignore_retrieval_failures</code>",id:"ignore_retrieval_failures",level:3}],c={toc:s},d="wrapper";function k(e){let{components:t,...n}=e;return(0,o.kt)(d,(0,r.Z)({},c,n,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("h1",{id:"license-check"},"License Check"),(0,o.kt)("p",null,"At VGV, we keep track of the rights and restrictions external dependencies might impose on Dart or Flutter projects."),(0,o.kt)("admonition",{type:"info"},(0,o.kt)("p",{parentName:"admonition"},"The License Check functionality is powered by ",(0,o.kt)("a",{parentName:"p",href:"https://cli.vgv.dev/docs/commands/check_licenses"},"Very Good CLI's license checker"),", for a deeper understanding of some ",(0,o.kt)("a",{parentName:"p",href:"#inputs"},"inputs")," refer to its ",(0,o.kt)("a",{parentName:"p",href:"https://cli.vgv.dev/docs/commands/check_licenses"},"documentation"),".")),(0,o.kt)("h2",{id:"steps"},"Steps"),(0,o.kt)("p",null,"The License Check workflow consists of the following steps:"),(0,o.kt)("ol",null,(0,o.kt)("li",{parentName:"ol"},"Setup Dart"),(0,o.kt)("li",{parentName:"ol"},"Set SSH Key (if provided)"),(0,o.kt)("li",{parentName:"ol"},"Install project dependencies"),(0,o.kt)("li",{parentName:"ol"},"Check licenses")),(0,o.kt)("h2",{id:"inputs"},"Inputs"),(0,o.kt)("h3",{id:"working_directory"},(0,o.kt)("inlineCode",{parentName:"h3"},"working_directory")),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"Optional")," The path to the root of the Dart or Flutter package."),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"Default")," ",(0,o.kt)("inlineCode",{parentName:"p"},'"."')),(0,o.kt)("h3",{id:"runs_on"},(0,o.kt)("inlineCode",{parentName:"h3"},"runs_on")),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"Optional")," An optional operating system on which to run the workflow."),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"Default")," ",(0,o.kt)("inlineCode",{parentName:"p"},'"ubuntu-latest"')),(0,o.kt)("h3",{id:"dart_sdk"},(0,o.kt)("inlineCode",{parentName:"h3"},"dart_sdk")),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"Optional")," Which Dart SDK version to use. It can be a version (e.g. ",(0,o.kt)("inlineCode",{parentName:"p"},"2.12.0"),") or a channel (e.g. ",(0,o.kt)("inlineCode",{parentName:"p"},"stable"),"):"),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"Default")," ",(0,o.kt)("inlineCode",{parentName:"p"},'"stable"')),(0,o.kt)("h3",{id:"allowed"},(0,o.kt)("inlineCode",{parentName:"h3"},"allowed")),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"Optional")," Only allow the use of certain licenses. The expected format is a comma-separated list."),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"Default")," ",(0,o.kt)("inlineCode",{parentName:"p"},'"MIT,BSD-3-Clause,BSD-2-Clause,Apache-2.0"')),(0,o.kt)("h3",{id:"forbidden"},(0,o.kt)("inlineCode",{parentName:"h3"},"forbidden")),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"Optional")," Deny the use of certain licenses. The expected format is a comma-separated list."),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"Default")," ",(0,o.kt)("inlineCode",{parentName:"p"},'""')),(0,o.kt)("admonition",{type:"warning"},(0,o.kt)("p",{parentName:"admonition"},"The allowed and forbidden options can't be used at the same time. If you want to use ",(0,o.kt)("inlineCode",{parentName:"p"},"forbidden")," set ",(0,o.kt)("inlineCode",{parentName:"p"},"allowed")," to an empty string.")),(0,o.kt)("h3",{id:"skip_packages"},(0,o.kt)("inlineCode",{parentName:"h3"},"skip_packages")),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"Optional")," Skip packages from having their licenses checked."),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"Default")," ",(0,o.kt)("inlineCode",{parentName:"p"},'""')),(0,o.kt)("h3",{id:"dependency_type"},(0,o.kt)("inlineCode",{parentName:"h3"},"dependency_type")),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"Optional")," The type of dependencies to check licenses for."),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"Default")," ",(0,o.kt)("inlineCode",{parentName:"p"},'"direct-main,transitive"')),(0,o.kt)("h3",{id:"ignore_retrieval_failures"},(0,o.kt)("inlineCode",{parentName:"h3"},"ignore_retrieval_failures")),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"Optional")," Disregard licenses that failed to be retrieved."),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"Default")," ",(0,o.kt)("inlineCode",{parentName:"p"},"false")))}k.isMDXComponent=!0}}]);