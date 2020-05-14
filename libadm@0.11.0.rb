class LibadmAT0110 < Formula
  desc "Audio Definition Model (ITU-R BS.2076) library"
  homepage "https://libadm.readthedocs.io/en/latest/"

  url "https://github.com/IRT-Open-Source/libadm/archive/0.11.0.tar.gz"
  sha256 "95a34b531ce93391623f2ff652936f8d136c176e94b0680909dab5e99555b2e7"

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    ENV.cxx11
    args = std_cmake_args
    args << "-DBUILD_SHARED_LIBS=ON"
    system "cmake", ".", *args
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <adm/adm.hpp>

      int main(int argc, char const* argv[]) {
        auto admProgramme = adm::AudioProgramme::create(
          adm::AudioProgrammeName("Alice and Bob talking in the forrest"));

        auto admDocument = adm::Document::create();
        admDocument->add(admProgramme);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-fvisibility=hidden", "-L#{lib}", "-ladm", "test.cpp", "-o", "test"
    system "./test"
  end
end
