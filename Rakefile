task :default => [ :build, :test ]

task :build do
    sh "make", "-C", "lib/flesher", "clean"
    sh "make", "-C", "lib/flesher"
end

task :test do
    tests = FileList["test/*.rb"]
    tests.each do |test|
        ruby "-I", ".", "-I", "lib/thunk", test
    end
end

task :clean do
    sh "make", "-C", "lib/flesher", "clean"
end
