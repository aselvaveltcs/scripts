#!/bin/sh

source $HOME/.profile
source $HOME/.private

download_coursebook() {
  url="$1"
  pdf_password="$2"
  pdf_file="${url##*/}"

  cd $HOME/Downloads && {
    curl -s --insecure -u ${COURSEBOOK_USER}:${COURSEBOOK_PASSWORD} -O "$url"
    
    qpdf --decrypt --password="$pdf_password" "$pdf_file" "$pdf_file.tmp"
    rm "$pdf_file"
    mv "$pdf_file.tmp" "$pdf_file"
  }

}

mail_content="$1"  
url=$(printf "$mail_content" | egrep --color=none -o 'https://.+')
pdf_password="$(printf "$mail_content" | egrep --color=none -o 'Autogenerated password is: .+' | sed 's/Autogenerated password is: //')"
download_coursebook "$url" "$pdf_password"
