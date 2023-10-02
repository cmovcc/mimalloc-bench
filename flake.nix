{
  description = "mimalloc-bench";
  # remains to be done:
  ## refinements:
  # - refine versions to match mimalloc-bench ones
  # - src_lua, src_rocksdb, src_redis should be flake inputs
  # - run derivation should have the bench.sh command as input
  ## improve support
  # - it should be possible to enable bench individually
  # (like what is done for allocators)
  # - add mimalloc 1
  # - fix dh (build requires Internet)
  # - fix hd (build requires Internet)
  # - fix mesh+nomesh (build requires Internet)
  # - pa: complex build process
  # - fix scalloc: runtime issue (with espresso, memory overcommit issue)
  # - fix sn (Nix issue)
  # - fix tcg: bazel build issue
  ## lack of nix knowledge
  # - fix scudo (sparse checkout)
  # - fix lp (sparse checkout)
  #   edit: it is possible to have sparse checkout repos, but not as flake inputs
  # - enableParallelBuilding by default globally
  # upstream fixes
  # - warning: rpmalloc
  # - warning: scalloc
  # - warning: supermalloc
  # - reproduciblity: tbbmalloc
  # - snmalloc?
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    src_mimalloc-bench = {
      url = "github:daanx/mimalloc-bench/";
      flake = false;
    };
    # lean benchmark
    src_lean3 = {
      url = "github:leanprover-community/lean";
      flake = false;
    };
    # allocator sources
    #src_dh = {
    #  url = "github:emeryberger/DieHard";
    #  flake = false;
    #};
    src_ff = {
      url = "github:bwickman97/ffmalloc";
      flake = false;
    };
    src_fg = {
      url = "github:UTSASRG/FreeGuard";
      flake = false;
    };
    src_gd = {
      url = "github:UTSASRG/Guarder";
      flake = false;
    };
    #src_hd = {
    #  url = "github:emeryberger/Hoard";
    #  flake = false;
    #};
    src_hm = {
      url = "github:GrapheneOS/hardened_malloc";
      flake = false;
    };
    src_iso = {
      url = "github:struct/isoalloc";
      flake = false;
    };
    src_je = {
      url = "github:jemalloc/jemalloc";
      flake = false;
    };
    src_lf = {
      url = "github:Begun/lockfree-malloc";
      flake = false;
    };
    src_lt = {
      url = "github:r-lyeh-archived/ltalloc";
      flake = false;
    };
    #src_mesh = {
    #  url = "github:plasma-umass/mesh";
    #  flake = false;
    #};
    src_mi = {
      url = "github:Microsoft/mimalloc";
      flake = false;
    };
    src_mng = {
      url = "github:richfelker/mallocng-draft";
      flake = false;
    };
    #src_pa
    src_rp = {
      url = "github:mjansson/rpmalloc";
      flake = false;
    };
    src_sc = {
      url = "github:cksystemsgroup/scalloc";
      flake = false;
    };
    #src_scudo
    src_sg = {
      url = "github:ssrg-vt/SlimGuard";
      flake = false;
    };
    src_sm = {
      url = "github:kuszmaul/SuperMalloc";
      flake = false;
    };
    #src_sn = {
    #  url = "github:Microsoft/snmalloc/0.6.2";
    #  flake = false;
    #};
    src_tbb = {
      url = "github:oneapi-src/oneTBB";
      flake = false;
    };
    src_tc = {
      url = "github:gperftools/gperftools";
      flake = false;
    };
    src_tcg = {
      url = "github:google/tcmalloc";
      flake = false;
    };
  };

  outputs = inputs@{self, nixpkgs, ...}:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      stdenv-mkDerivationP = args:
        pkgs.stdenv.mkDerivation (args // {
          enableParallelBuilding = true;
        });
      clangStdenv-mkDerivationP = args:
        pkgs.clangStdenv.mkDerivation (args // {
          enableParallelBuilding = true;
        });
      stdenv = pkgs.stdenv;
      clangStdenv = pkgs.clangStdenv;
      lib = pkgs.lib;

      #additionalInputs = {
      #  src_lp = pkgs.fetchgit {
      #    url = "https://github.com/Webkit/Webkit";
      #    sparseCheckout = [ "Source/bmalloc/libpas" ];
      #    hash = "sha256-2HBbqvjhWcQbdEnPaKL3A5cDeUHDBU6v5Z9C5uOTkzc=";
      #  };
      #};

      #TODO: fix it, requires Internet access during build
      #TODO: support Darwin
      #dh = stdenv.mkDerivation {
      #  name = "dh";
      #  src = inputs.src_dh;
      #  nativeBuildInputs = with pkgs; [ git ];
      #  buildPhase = ''
      #    TARGET=libdieharder make -C src linux-gcc-64
      #  '';
      #  installPhase = "touch $out";
      #};
      ff = stdenv.mkDerivation {
        name = "ff";
        src = inputs.src_ff;
        installPhase = "mkdir $out && cp libffmallocnpmt.so $out";
      };
      fg = clangStdenv.mkDerivation {
        name = "fg";
        src = inputs.src_fg;
        makeFlags = [ "SSE2RNG=1" ];
        installPhase = "mkdir $out && cp libfreeguard.so $out";
      };
      gd = clangStdenv.mkDerivation {
        name = "gd";
        src = inputs.src_gd;
        installPhase = "mkdir $out && cp libguarder.so $out";
      };
      #TODO: fix it, requires Internet access during build
      #TODO: support Darwin
      #hd = stdenv.mkDerivation {
      #  name = "hd";
      #  src = inputs.src_hd;
      #  buildPhase = ''
      #    cd src
      #    make
      #  '';
      #  installPhase = "ls && touch $out";
      #};
      hm = stdenv.mkDerivation {
        name = "hm";
        src = inputs.src_hm;
        installPhase = "mkdir -p $out/out && cp out/libhardened_malloc.so $out/out";
      };
      hml = stdenv.mkDerivation {
        name = "hml";
        src = inputs.src_hm;
        makeFlags = [ "VARIANT=light" ];
        installPhase = "mkdir -p $out/out-light && cp out-light/libhardened_malloc-light.so $out/out-light";
      };
      iso = clangStdenv.mkDerivation {
        name = "iso";
        src = inputs.src_iso;
        buildFlags = [ "library" ];
        installPhase = "mkdir -p $out/build && cp build/libisoalloc.so $out/build";
      };
      je = stdenv.mkDerivation {
        name = "je";
        src = inputs.src_je;
        nativeBuildInputs = with pkgs; [ autoconf automake ];
        configurePhase = ''
          ./autogen.sh --enable-doc=no --enable-static=no --disable-stats
        '';
        enableParallelBuilding = true;
        installPhase = "mkdir -p $out/lib && cp lib/libjemalloc.so $out/lib";
      };
      lf = stdenv.mkDerivation {
        name = "lf";
        src = inputs.src_lf;
        buildFlags = [ "liblite-malloc-shared.so" ];
        installPhase = "mkdir $out && cp liblite-malloc-shared.so $out";
      };
      #lp = clangStdenv.mkDerivation {
      #  name = "lp";
      #  src = additionalInputs.src_lp;
      #  configurePhase = ''
      #    cd Source/bmalloc/libpas
      #  '';
      #  makeFlags = [
      #    "LDFLAGS='-lpthread -latomic -pthread'"
      #  ];
      #  installPhase = "touch $out";
      #};
      lt = stdenv.mkDerivation {
        name = "lt";
        src = inputs.src_lt;
        buildPhase = "make -C gnu.make.lib";
        enableParallelBuilding = true;
        installPhase = "mkdir -p $out/gnu.make.lib && cp gnu.make.lib/libltalloc.so $out/gnu.make.lib";
      };
      #TODO: fix it, requires Internet access during build
      #mesh = stdenv.mkDerivation {
      #  name = "mesh";
      #  src = inputs.src_mesh;
      #  nativeBuildInputs = with pkgs; [ cmake git ];
      #  # issue 96
      #  enableParallelBuilding = false;
      #  installPhase = "touch $out";
      #};
      # mimalloc + secure version
      mi = stdenv.mkDerivation {
        name = "mi";
        src = inputs.src_mi;
        nativeBuildInputs = with pkgs; [ cmake ninja ];
        cmakeFlags = [
          "-DCMAKE_INSTALL_LIBDIR=out/release"
        ];
        installPhase = "mkdir -p $out/out/release && cp libmimalloc.so $out/out/release";
      };
      mi-sec = stdenv.mkDerivation {
        name = "mi-sec";
        src = inputs.src_mi;
        nativeBuildInputs = with pkgs; [ cmake ninja ];
        cmakeFlags = [
          "-DMI_SECURE=ON"
          "-DCMAKE_INSTALL_LIBDIR=out/secure"
        ];
        installPhase = "mkdir -p $out/out/secure && cp libmimalloc-secure.so $out/out/secure";
      };
      mng = stdenv.mkDerivation {
        name = "mng";
        src = inputs.src_mng;
        enableParallelBuilding = true;
        installPhase = "mkdir $out && cp libmallocng.so $out";
      };
      #pa
      rp = clangStdenv.mkDerivation {
        name = "rp";
        src = inputs.src_rp;
        nativeBuildInputs = with pkgs; [ python3 ninja ];
        configurePhase = "python3 configure.py";
        #TODO: upstream fix?
        NIX_CFLAGS_COMPILE = "-Wno-embedded-directive";
        installPhase = "mkdir $out && cp -r bin $out";
        enableParallelBuilding = true;
      };
      sc = stdenv.mkDerivation {
        name = "sc";
        src = inputs.src_sc;
        nativeBuildInputs = with pkgs; [
          (python3.withPackages (ps: with ps; [ gyp ]))
        ];
        configurePhase = "gyp --depth=. scalloc.gyp";
        #TODO: upstream fix?
        NIX_CFLAGS_COMPILE = "-Wno-stringop-overflow -Wno-stringop-truncation";
        makeFlags = [ "BUILDTYPE=Release"];
        installPhase = "mkdir -p $out/out/Release/lib.target/ && cp out/Release/lib.target/libscalloc.so $out/out/Release/lib.target/ ";
      };
      sg = stdenv.mkDerivation {
        name = "sg";
        src = inputs.src_sg;
        installPhase = "mkdir $out && cp libSlimGuard.so $out";
      };
      sm = stdenv.mkDerivation {
        name = "sm";
        src = inputs.src_sm;
        configurePhase = "cd release";
        NIX_CFLAGS_COMPILE = "-Wno-alloc-size-larger-than";
        enableParallelBuilding = true;
        installPhase = "cd .. && mkdir -p $out/release/lib/ && cp release/lib/libsupermalloc.so $out/release/lib";
      };
      #sn = clangStdenv.mkDerivation {
      #  name = "sn";
      #  src = inputs.src_sn;
      #  nativeBuildInputs = with pkgs; [ cmake ninja ];
      #  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=build" ];
      #  NIX_CFLAGS_COMPILE = "-Wno-ignored-attributes";
 #libs#nmallocshim.so libsnmallocshim-checks.so
      #  installPhase = "touch $out";
      #};
      tbb = stdenv.mkDerivation {
        name = "tbb";
        src = inputs.src_tbb;
        nativeBuildInputs = with pkgs; [ cmake ];
        cmakeFlags = [
          "-DCMAKE_BUILD_TYPE=Release"
          "-DTBB_BUILD=OFF"
          "-DTBB_TEST=OFF"
          "-DTBB_OUTPUT_DIR_BASE=bench"
          # otherwise, reproducibility issue leads to nix build failure
          # TODO: upstream fix?
          # https://discourse.nixos.org/t/rpath-of-binary-contains-a-forbidden-reference-to-build/12200
          "-DCMAKE_SKIP_BUILD_RPATH=ON"
        ];
        installPhase = "mkdir $out && cp -r bench_release $out";
      };
      tc = stdenv.mkDerivation {
        name = "tc";
        src = inputs.src_tc;
        nativeBuildInputs = with pkgs; [ autoconf automake libtool ];
        configurePhase = ''
          ./autogen.sh
          CXXFLAGS="$CXXFLAGS -w -DNDEBUG -O2" ./configure --enable-minimal --disable-debugalloc
        '';
        installPhase = "mkdir -p $out/.libs && cp .libs/libtcmalloc_minimal.so $out/.libs";
      };
      tcg = pkgs.buildBazelPackage rec {
        name = "tcg";
        bazel = pkgs.bazel_6;
        src = inputs.src_tcg;
        #nativeBuildInputs = with pkgs; [ bazel ];
        #bazelFlags = "-c opt tcmalloc";
        fetchAttrs = {
          sha256 = "";
        };
        buildAttrs = {
          outputs = [ "out/bazel-bin/t" ];
          installPhase = "pwd && ls && mkdir -p $out/bazel-bin/tcmalloc && cp bazel-bin/tcmalloc/libtcmalloc.so $out/bazel-bin/tcmalloc";
        };
        bazelTarget = [ "//tcmalloc:tcmalloc" ];
        #buildPhase = "bazel build -c opt tcmalloc";
        #installPhase = "ls && mkdir -p $out/bazel-bin/tcmalloc && cp bazel-bin/tcmalloc/libtcmalloc.so $out/bazel-bin/tcmalloc";
      };
 
      # redis
      version_redis = "6.2.7";
      src_redis = builtins.fetchTarball {
        url = "http://download.redis.io/releases/redis-${version_redis}.tar.gz";
        sha256 = "sha256:0kab6v38x9chiv0z8r9fr9abdkscjlmj2przqp7k2mspcmzb22nj";
      };
      redis = stdenv.mkDerivation {
        name = "redis";
        nativeBuildInputs = with pkgs; [ pkg-config ];
        src = src_redis;
        makeFlags = [
          "USE_JEMALLOC=no"
          "MALLOC=libc"
          "BUILD_TLS=no"
        ];
        #TODO: this should not be required
        enableParallelBuilding = true;
        installPhase = "mkdir $out && cp -r * $out";
      };
      # lean
      lean3 = stdenv.mkDerivation {
        name = "lean3";
        src = inputs.src_lean3;
        nativeBuildInputs = with pkgs; [ cmake gmp ];
        cmakeFlags = [
          "-DCUSTOM_ALLOCATORS=OFF"
          "-DLEAN_EXTRA_CXX_FLAGS=\"-w\""
          "-DCMAKE_INSTALL_LIBDIR=out/release"
        ];
        cmakeDir = "../src";
        #TODO: this should not be required
        enableParallelBuilding = true;
        installPhase = "cd .. && mkdir $out && cp -r * $out";
      };
      version_rocksdb = "8.1.1";
      src_rocksdb = builtins.fetchTarball {
        url = "https://github.com/facebook/rocksdb/archive/refs/tags/v${version_rocksdb}.zip";
        sha256 = "sha256:03jpmhyrz8j0y7jwj8hws9rhhak5k1mhliilrb5n4jahrssm3n7g";
      };
      rocksdb = stdenv.mkDerivation {
        name = "rocksdb";
        nativeBuildInputs = with pkgs; [ bash util-linux which gflags perl snappy ];
        src = src_rocksdb;
        makeFlags = [
          "DISABLE_WARNING_AS_ERROR=1"
          "DISABLE_JEMALLOC=1"
        ];
        #TODO: this should not be required
        enableParallelBuilding = true;
        buildFlags = [ "db_bench" ];
        installPhase = "mkdir $out && cp -r * $out";
      };
      # bench
      bench-sh6bench = builtins.fetchTarball {
        url = "http://www.microquill.com/smartheap/shbench/bench.zip";
        sha256 = "sha256:0pdf01d7mdg7mf1pxw3dcizfm7s93b9df8sjq6pzmrfl3dcwjq33";
      };
      bench-sh8bench = builtins.fetchTarball {
        url = "http://www.microquill.com/smartheap/SH8BENCH.zip";
        sha256 = "sha256:0w4djm17bw5hn7bx09398pkv1gzknlsxvi6xxjn44qnklc2r47ci";
      };
      bench-largepdf = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/geekaaron/Resources/master/resources/Writing_a_Simple_Operating_System--from_Scratch.pdf";
        sha256 = "sha256:04pddvdhy4x2fh9jjq9rwl52r8svcam7izg48z64kh75x611hm29";
      };
      version_lua = "5.4.4";
      src_lua = builtins.fetchTarball {
        url = "https://github.com/lua/lua/archive/refs/tags/v${version_lua}.zip";
        sha256 = "sha256:0fd4dam1ryxrfybfsb3jd8f3yp7clijapsimddy2i1w1fkk532gz";
      };
 
      # Stage 1: fetch mimalloc-bench repo + basic benches external resources
      bench1 = stdenv.mkDerivation {
        name = "bench1";
        nativeBuildInputs = with pkgs; [ dos2unix patch ];
        src = inputs.src_mimalloc-bench;
        buildPhase = ''
          # sh6bench + sh8bench
          pushd bench/shbench
          cp ${bench-sh6bench} sh6bench.c
          dos2unix sh6bench.patch
          dos2unix sh6bench.c
          patch -p1 -o sh6bench-new.c sh6bench.c sh6bench.patch
          cp ${bench-sh8bench} sh8bench.c
          dos2unix sh8bench.patch
          dos2unix sh8bench.c
          patch -p1 -o sh8bench-new.c sh8bench.c sh8bench.patch
          popd

          # large pdf file
          mkdir extern
          cp ${bench-largepdf} extern/large.pdf

          # lua
          cp -r ${src_lua} extern/lua
        '';
        installPhase = "mkdir $out && cp -r * $out";
      };

      # Stage 2: build basic benches
      # and add it to previous stage
      bench2 = stdenv.mkDerivation {
        name = "bench2";
        nativeBuildInputs = with pkgs; [ dos2unix patch cmake ];
        src = bench1;
        cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=out/bench" ];
        cmakeDir = "../bench";
        #TODO: this should not be required
        enableParallelBuilding = true;
        installPhase = "cd .. && mkdir $out && cp -r * $out";
      };

      # Stage 3: build other benches (redis, lean3, rocksdb)
      # and add it to previous stage
      bench3_ = benches:
        let
          objs = builtins.map (name: builtins.getAttr name benches) (builtins.attrNames benches);
          build_phase = lib.strings.concatMapStrings (obj:
            "${obj.cmd1}"
          ) objs;
        in
        stdenv.mkDerivation {
          name = "bench3";
          nativeBuildInputs = [ pkgs.util-linux pkgs.rsync ] ++ (builtins.map (obj: obj.drv) objs);
          src = bench2;
          buildPhase = build_phase;
          installPhase = "mkdir $out && cp -r * $out";
      };

      # Stage 4: build selected allocators
      # and add it to previous stage
      bench4_ = benches: allocs:
        let
          objs = builtins.map (name: builtins.getAttr name allocs) (builtins.attrNames allocs);
          conf_phase = lib.strings.concatMapStrings (obj:
            "cp -r ${obj.drv} extern/${obj.drv.name}\n"
          ) objs;
          build_phase = lib.strings.concatMapStrings (obj:
            "${obj.fix}"
          ) objs;
        in
        stdenv.mkDerivation {
          src = bench3_ benches;
          name = "bench4";
          nativeBuildInputs = [ pkgs.util-linux ] ++ (builtins.map (obj: obj.drv) objs);
          configurePhase = conf_phase;
          buildPhase = build_phase;
          installPhase = "mkdir $out && cp -r * $out";
          #TODO: remove
          #allocs = allocs;
          #lib = pkgs.lib;
          #installPhase = "touch $out";
      };

      # Bench selected allocators
      run_ = benches: allocs:
        let
          str_allocs = lib.concatMapStrings
            (name: "${builtins.getAttr name allocs} ")
            (builtins.attrNames allocs);
        in
        stdenv.mkDerivation {
          name = "run";
          src = bench4_ benches allocs;
          nativeBuildInputs = with pkgs; [
            util-linux bash time
            readline #lua
            bc #redis
            ghostscript_headless #gs
            ruby #rbstress
            z3 #z3
            cmake gmp #lean
          ];
          dontUseCmakeConfigure = true;
          buildPhase = ''
            # workaround around cmake issue
            mkdir -p extern/lean/out/release
            pushd extern/lean/out/release
            cmake ../../src -DCUSTOM_ALLOCATORS=OFF -DLEAN_EXTRA_CXX_FLAGS="-w"
            popd
            ## prepare benchmarks
            touch extern/versions.txt
            # allt is an alias for tests_all{1,2,3,4} instead of tests_all{1,2}
            sed -i 's/tests_allt="$tests_all1 $tests_all2"/tests_allt="$tests_all1 $tests_all2 $tests_all3 $tests_all4"/' bench.sh
            # lean and lean-mathlib should not be excluded
            sed -i 's/tests_exclude="$tests_exclude lean lean-mathlib"/tests_exclude="$tests_exclude"/' bench.sh
            # TODO: upstream bug, lf is not used
            sed -i 's/alloc_all="sys/alloc_all="lf sys/' bench.sh
            # fix mi-sec installation path
            mkdir out
            mv build out/bench
            pushd out/bench
            # benchmark
            #bash ../../bench.sh sys $str_allocs espresso
            bash ../../bench.sh sys rocksdb lean lean-mathlib redis espresso
            # current state: everything is compiling and running with sys (glibc)
            # tests1: ok
            # tests2: ok
            # tests3: ok
            # tests4: ok (except spec-bench)
            popd
          '';
          installPhase = "cp out/bench/benchres.csv $out && false";
          #installPhase = "mkdir $out && cp -r * $out";
      };

      benches = {
        redis = { drv = redis; cmd2 = "";
          cmd1 = ''
            cp -r ${redis} extern/redis-${version_redis}
          '';
        };
        lean3 = { drv = lean3;
          # exclude out/release to avoid cmake issues during benchmark
          # as cmake cache does not support to be moved
          cmd1 = ''
            rsync -av ${lean3}/ extern/lean --exclude=out/release/*
            mkdir extern/mathlib
            cp -u extern/lean/leanpkg/leanpkg.toml extern/mathlib
          '';
          # workaround around cmake issue
          cmd2 = ''
            mkdir -p extern/lean/out/release
            pushd extern/lean/out/release
            cmake ../../src -DCUSTOM_ALLOCATORS=OFF -DLEAN_EXTRA_CXX_FLAGS="-w"
            popd
          '';
        };
        #TODO: disable rocksdb for now, issue with CI
        #rocksdb = { drv = rocksdb; cmd2 = "";
        #  cmd1 = ''
        #    cp -r ${rocksdb} extern/rocksdb-${version_rocksdb}
        #  '';
        #};
      };
      allocs = {
        ##dh = { drv = dh; fix = ""; };
        #ff = { drv = ff; fix = ""; };
        #fg = { drv = fg; fix = ""; };
        #gd = { drv = gd; fix = ""; };
        ##hd = { drv = hd; fix = ""; };
        #hm = { drv = hm; fix = ""; };
        #hml = { drv = hml;
        #  fix = "sed -i 's/hm\\/out-light\\/libhardened_malloc-light/hml\\/out-light\\/libhardened_malloc-light/' bench.sh\n";
        #};
        #iso = { drv = iso; fix = ""; };
        #je = { drv = je; fix = ""; };
        #lf = { drv = lf; fix = ""; };
        ##lp = { drv = lp; fix = ""; };
        #lt = { drv = lt; fix = ""; };
        ##mesh nomesh
        #mi = { drv = mi; fix = ""; };
        #mi-sec = { drv = mi-sec;
        #  fix = "sed -i 's/mi\\/out\\/secure\\/libmimalloc-secure/mi-sec\\/out\\/secure\\/libmimalloc-secure/' bench.sh\n";
        #};
        #mng = { drv = mng; fix = ""; };
        ##pa
        #rp = { drv = rp; fix = ""; };
        #sc = { drv = sc; fix = ""; };
        ##scudo
        #sg = { drv = sg; fix = ""; };
        #sm = { drv = sm; fix = ""; };
        ##sn
        #tbb = { drv = tbb; fix = ""; };
        #tc = { drv = tc; fix = ""; };
        ##tcg
      };
      bench3 = bench3_ benches;
      bench4 = bench4_ benches allocs;
      run = run_ benches allocs;
    in
    {
      lib = { inherit run_ bench4_ allocs; };
      packages.${system} = {
        inherit
          ## allocators
          #dh TODO: broken, build requires Internet access
          ff
          fg
          gd
          #hd TODO: broken, build requires Internet access
          hm hml
          iso
          je
          lf #TODO: no test runs, mimalloc-bench bug
          #lp TODO: fix build, rely on sparse checkout
          lt
          #mesh+nomesh TODO: broken, build requires Internet access
          mi mi-sec
          mng
          #pa TODO: build seems rather complicated
          rp
          sc #TODO: fails on espresso, issue with memory overcommit? nix environment = culprit?
          #scudo sparse checkout as nix input?
          sg
          sm
          #sn+sn-sec TODO: build issue within flake env...
          tbb
          tc
          tcg
          
          ## specific benches
          lean3
          redis
          rocksdb

          ## bench environment stages
          bench1
          bench2
          bench3
          bench4
          run; default=run; };
      #checks.${system} = {
      #  inherit steel-experiments;
      #};
    };
}
