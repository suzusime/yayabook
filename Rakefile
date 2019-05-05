TARGET = "README"
PDFLATEX = "latexmk"
PDFLATEXFLAGS = "-lualatex"

# クラスファイルがchapterを持っているか
HAS_CHAPTER = true

include_files = ["article1"]

# 自動生成される引数たち
pandoc_args = ""
include_texs = []
cls_files = []

# pandocのバージョンを判別
def get_pandoc_version()
  rawtext = `pandoc --version`
  version_string = ""
  # 1行目の最後にバージョン番号があると仮定する
  rawtext.each_line { |line|
    version_string = line.match(/[0-9.]+$/)[0]
    break
  }
  major_version = version_string.match(/^[0-9]+/)[0]
  return major_version
end

# pandocのバージョンによって引数を変える
if get_pandoc_version == "1" then
  pandoc_args = "-f markdown+ignore_line_breaks -t latex -N --latex-engine=lualatex"
  if HAS_CHAPTER then
    pandoc_args += " --chapter"
  end
else
  # バージョン1以外は2と同じと扱う
  pandoc_args = "-f markdown+ignore_line_breaks -t latex -N --pdf-engine=lualatex"
  if HAS_CHAPTER then
    pandoc_args += " --top-level-division=chapter"
  end
end

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

# 継続ビルド
sleep_time = 3
desc "#{sleep_time}秒毎にビルドを走らせる"
task :cont do
  at_exit {
    loop do
      system("rake")
      sleep 5
    end
  }
end

task :clean do
  rm_f("#{TARGET}.pdf")
  cd "intermediate" do sh "git clean -dfX" end
  cd "classes" do sh "git clean -dfX" end
end

task :default => "#{TARGET}.pdf"