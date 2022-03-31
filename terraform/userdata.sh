 <<EOT
#cloud-config
# update apt on boot
package_update: true
# install nginx
packages:
- nginx
- awscli
- s3cmd
write_files:
- content: |
    <!DOCTYPE html>
    <html>
    <head>
      <title>Assignment 1</title>
      <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
      <style>
        html, body {
          background: #000;
          height: 100%;
          width: 100%;
          padding: 0;
          margin: 0;
          display: flex;
          justify-content: center;
          align-items: center;
          flex-flow: column;
        }
        img { width: 250px; }
        svg { padding: 0 40px; }
        p {
          color: #fff;
          font-family: 'Courier New', Courier, monospace;
          text-align: center;
          padding: 10px 30px;
        }
      </style>
    </head>
    <body>
      <p>Welcome to Grandpa's Whiskey </p>
      <p> instanceIP </p>
    </body>
    </html>
  path: /usr/share/app/index.html
  permissions: '0644'
runcmd:
- export instanceIP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
- sed  "s|instanceIP|$instanceIP|" /usr/share/app/index.html > ./index.html
- cp index.html /var/www/html/index.html
EOT