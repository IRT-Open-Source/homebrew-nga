class Libbw64 < Formula
  desc "Broadcast Wave 64 (ITU-R BS.2088) library"
  homepage "https://libbw64.readthedocs.io/en/latest/"

  url "https://github.com/IRT-Open-Source/libbw64/archive/0.9.0.tar.gz"
  sha256 "fbe16fbf25f2287e232ddc6e9bec6114654e19c63f4798f88a43c1de5642ae03"

  head "https://github.com/IRT-Open-Source/libbw64.git"

  depends_on "cmake" => :build

  def install
    ENV.cxx11
    args = std_cmake_args
    system "cmake", ".", *args
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <bw64/bw64.hpp>
      #include <vector>

      int main(int argc, char const* argv[]) {
        auto bw64File = bw64::writeFile("test.wav");

        std::vector<float> buffer(512, 0.f);
        bw64File->write(&buffer.front(), buffer.size());

        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test"
    system "./test"
  end
end
