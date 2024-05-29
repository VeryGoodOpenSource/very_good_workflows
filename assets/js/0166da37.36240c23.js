"use strict";(self.webpackChunkworkflows_docs=self.webpackChunkworkflows_docs||[]).push([[725],{3189:(e,n,o)=>{o.r(n),o.d(n,{assets:()=>a,contentTitle:()=>i,default:()=>p,frontMatter:()=>t,metadata:()=>l,toc:()=>c});var s=o(4848),r=o(8453);const t={sidebar_position:7},i="Pana",l={id:"workflows/pana",title:"Pana",description:"We use the Dart tool pana to validate that your pub score will be the max possible score before publishing a package to pub.dev.",source:"@site/docs/workflows/pana.md",sourceDirName:"workflows",slug:"/workflows/pana",permalink:"/docs/workflows/pana",draft:!1,unlisted:!1,editUrl:"https://github.com/VeryGoodOpenSource/very_good_workflows/tree/main/site/docs/workflows/pana.md",tags:[],version:"current",sidebarPosition:7,frontMatter:{sidebar_position:7},sidebar:"tutorialSidebar",previous:{title:"Mason Publish",permalink:"/docs/workflows/mason_publish"},next:{title:"Semantic Pull Request",permalink:"/docs/workflows/semantic_pull_request"}},a={},c=[{value:"Steps",id:"steps",level:2},{value:"Inputs",id:"inputs",level:2},{value:"<code>pana_version</code>",id:"pana_version",level:3},{value:"<code>min_score</code>",id:"min_score",level:3},{value:"<code>working_directory</code>",id:"working_directory",level:3},{value:"<code>runs_on</code>",id:"runs_on",level:3},{value:"Example Usage",id:"example-usage",level:2}];function d(e){const n={a:"a",code:"code",h1:"h1",h2:"h2",h3:"h3",li:"li",ol:"ol",p:"p",pre:"pre",strong:"strong",...(0,r.R)(),...e.components};return(0,s.jsxs)(s.Fragment,{children:[(0,s.jsx)(n.h1,{id:"pana",children:"Pana"}),"\n",(0,s.jsxs)(n.p,{children:["We use the Dart tool ",(0,s.jsx)(n.a,{href:"https://pub.dev/packages/pana",children:"pana"})," to validate that your pub score will be the max possible score before publishing a package to ",(0,s.jsx)(n.a,{href:"https://pub.dev",children:"pub.dev"}),"."]}),"\n",(0,s.jsx)(n.h2,{id:"steps",children:"Steps"}),"\n",(0,s.jsx)(n.p,{children:"The pana workflow consists of the following steps:"}),"\n",(0,s.jsxs)(n.ol,{children:["\n",(0,s.jsx)(n.li,{children:"Install pana"}),"\n",(0,s.jsx)(n.li,{children:"Verify pana score"}),"\n"]}),"\n",(0,s.jsx)(n.h2,{id:"inputs",children:"Inputs"}),"\n",(0,s.jsx)(n.h3,{id:"pana_version",children:(0,s.jsx)(n.code,{children:"pana_version"})}),"\n",(0,s.jsxs)(n.p,{children:[(0,s.jsx)(n.strong,{children:"Optional"})," Which version of ",(0,s.jsx)(n.code,{children:"package:pana"})," to use (See the available versions ",(0,s.jsx)(n.a,{href:"https://pub.dev/packages/pana/changelog",children:"here"}),")."]}),"\n",(0,s.jsx)(n.h3,{id:"min_score",children:(0,s.jsx)(n.code,{children:"min_score"})}),"\n",(0,s.jsxs)(n.p,{children:[(0,s.jsx)(n.strong,{children:"Optional"})," The minimum score allowed."]}),"\n",(0,s.jsxs)(n.p,{children:[(0,s.jsx)(n.strong,{children:"Default"})," ",(0,s.jsx)(n.code,{children:"120"})]}),"\n",(0,s.jsx)(n.h3,{id:"working_directory",children:(0,s.jsx)(n.code,{children:"working_directory"})}),"\n",(0,s.jsxs)(n.p,{children:[(0,s.jsx)(n.strong,{children:"Optional"})," The path to the root of the Dart package."]}),"\n",(0,s.jsxs)(n.p,{children:[(0,s.jsx)(n.strong,{children:"Default"})," ",(0,s.jsx)(n.code,{children:'"."'})]}),"\n",(0,s.jsx)(n.h3,{id:"runs_on",children:(0,s.jsx)(n.code,{children:"runs_on"})}),"\n",(0,s.jsxs)(n.p,{children:[(0,s.jsx)(n.strong,{children:"Optional"})," The operating system on which to run the workflow."]}),"\n",(0,s.jsxs)(n.p,{children:[(0,s.jsx)(n.strong,{children:"Default"})," ",(0,s.jsx)(n.code,{children:'"ubuntu-latest"'})]}),"\n",(0,s.jsx)(n.h2,{id:"example-usage",children:"Example Usage"}),"\n",(0,s.jsx)(n.pre,{children:(0,s.jsx)(n.code,{className:"language-yaml",children:"name: My Workflow\n\non: pull_request\n\njobs:\n  build:\n    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/pana.yml@v1\n    with:\n      min_score: 95\n      working_directory: 'examples/my_flutter_package'\n"})})]})}function p(e={}){const{wrapper:n}={...(0,r.R)(),...e.components};return n?(0,s.jsx)(n,{...e,children:(0,s.jsx)(d,{...e})}):d(e)}},8453:(e,n,o)=>{o.d(n,{R:()=>i,x:()=>l});var s=o(6540);const r={},t=s.createContext(r);function i(e){const n=s.useContext(t);return s.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function l(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(r):e.components||r:i(e.components),s.createElement(t.Provider,{value:n},e.children)}}}]);