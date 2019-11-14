bazel --output_user_root=/dockerdata/cathy/bazel_build_1.15 build --config=opt --config=cuda --disk_cache=/dockerdata/cathy/bazel_cache_1.15 //tensorflow/tools/pip_package:build_pip_package
./bazel-bin/tensorflow/tools/pip_package/build_pip_package /data1/cathy/tf-source_code/tf-install/1.15/build
#sh /data1/cathy/tf-source_code/tf-install/1.15/build/install.sh
