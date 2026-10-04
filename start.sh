#!/usr/bin/env bash
# TaskFlow static server — serves PROJECT_DIR/dist on $PORT (default 3000).
# Writes deployment-output.json to $OPENCODE_WEB_DIR for the controller.
set -euo pipefail

/usr/bin/time -p bash -c 'cd "$(dirname "$0")" && pwd'
cd "$(dirname "$0")"
/usr/bin/time -p pwd

export PROJECT_DIR="$PWD"
export PORT="${PORT:-3000}"
export DIST_DIR="$PROJECT_DIR/dist"
WEB_DIR="${OPENCODE_WEB_DIR:-/home/runner/work/_temp/omgithub-web}"
export WEB_OUT="$WEB_DIR/deployment-output.json"

/usr/bin/time -p test -d "$DIST_DIR"
/usr/bin/time -p test -f "$DIST_DIR/index.html"
/usr/bin/time -p mkdir -p "$WEB_DIR"

/usr/bin/time -p node -e 'const fs=require("fs");fs.writeFileSync(process.env.WEB_OUT,JSON.stringify({project:process.env.PROJECT_DIR,directory:process.env.DIST_DIR}));console.log(fs.readFileSync(process.env.WEB_OUT,"utf8"))'
/usr/bin/time -p cat "$WEB_DIR/deployment-output.json"
/usr/bin/time -p node --version

echo "Serving $DIST_DIR on port $PORT (project $PROJECT_DIR)"

/usr/bin/time -p test -n "$PORT"
# Foreground static server (no dependencies). Kept in foreground for tmux app-server.
PORT="$PORT" DIST_DIR="$DIST_DIR" /usr/bin/time -p node -e '
const http=require("http"),fs=require("fs"),path=require("path");
const root=process.env.DIST_DIR, port=Number(process.env.PORT||3000);
const mime={".html":"text/html",".js":"application/javascript",".css":"text/css",".json":"application/json",".svg":"image/svg+xml",".png":"image/png",".jpg":"image/jpeg",".webp":"image/webp",".ico":"image/x-icon"};
http.createServer((req,res)=>{
  try{
    const u=new URL(req.url,"http://localhost");
    let p=path.normalize(path.join(root,decodeURIComponent(u.pathname)));
    if(!p.startsWith(root)){res.writeHead(404);res.end();return}
    if(fs.existsSync(p)&&fs.statSync(p).isDirectory())p=path.join(p,"index.html");
    if(!fs.existsSync(p))p=path.join(root,"index.html");
    res.setHeader("Content-Type",mime[path.extname(p)]||"application/octet-stream");
    res.setHeader("Cache-Control","no-cache");
    res.end(fs.readFileSync(p));
  }catch(e){res.writeHead(404);res.end("not found")}
}).listen(port,"0.0.0.0",()=>console.log("listening "+port));
'
