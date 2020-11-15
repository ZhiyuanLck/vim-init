syn match vimHiCtermFgBg contained "\ccterm[fb]g\s*=\s*" nextgroup=vimCtermColor,vimHiCtermColor,vimFgBgAttrib,vimHiCtermError
let s:syn_cterm_color = 'syn match vimCtermColor contained /\d{1-3}/ contains='
let s:colors = []
for i in range(256)
  call add(s:colors, 'vimCtermColor'.i)
  exec 'syn match vimCtermColor'.i.' /'.i.'/ contained'
  let j = (i + 128) % 256
  let j = abs(255 - 2*i) < 20 ? (i + 128) % 256 : 255 - i
  exec 'hi vimCtermColor'.i.' ctermbg='.i.' ctermfg='.j
  exec 'syn cluster vimHiCluster add=vimCtermColor'.i
endfor
exec s:syn_cterm_color.join(s:colors, ',')
