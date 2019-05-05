TARGET = "README"
PDFLATEX = "latexmk"
PDFLATEXFLAGS = "-lualatex"

pandoc_args = "-f markdown+ignore_line_breaks -t latex -N --top-level-division=chapter --pdf-engine=lualatex"

include_files = ["article1"]

# これは自動生成される
include_texs = []
cls_files = []

#----- クラスファイルの生成ここから
YAYACLASSES = ["yayaarticle.cls", "yayareport.cls", "yayabook.cls", "yayaslide.cls"]

YAYACLASSES.each do |f|
  cls_name = "classes/#{f}"
  cls_files << cls_name
  file cls_name => ["classes/yayacls.dtx", "classes/yayacls.ins"] do |t|
    cd "classes" do
      sh "lualatex yayacls.ins"
    end
  end
end
#----- クラスファイルの生成ここまで

# #{TARGET}.mdから読み込まれているファイルをTeXに変換
include_files.each do |f|
  input_md = "#{f}.md"
  texfile_name = "intermediate/#{f}.tex"
  include_texs << texfile_name
  file texfile_name => input_md do |t|
    sh "pandoc #{pandoc_args} -o #{t.to_s} #{t.source}"
  end
end

file "intermediate/#{TARGET}.tex" => ["#{TARGET}.md"] do |t|
  sh "pandoc #{pandoc_args} --standalone -o #{t.to_s} #{t.source}"
end

file "intermediate/#{TARGET}.pdf"\
  => ["intermediate/#{TARGET}.tex"] + include_texs + cls_files\
do |t|
  cd "intermediate" do
    sh "#{PDFLATEX} #{PDFLATEXFLAGS} #{TARGET}.tex"
  end
end

desc "#{TARGET}.md をもとに #{TARGET}.pdf を生成する"
file "#{TARGET}.pdf" => "intermediate/#{TARGET}.pdf" do |t|
  cp(t.source, t.to_s)
end