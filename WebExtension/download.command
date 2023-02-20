rm $TMPDIR/dist.zip 2> /dev/null || true
curl -L -o $TMPDIR/dist.zip https://github.com/raindropio/app/releases/latest/download/safari-ios-prod.zip
unzip -o $TMPDIR/dist.zip -d WebExtension/dist