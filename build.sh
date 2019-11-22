bazel --output_user_root=/dockerdata/cathy/bazel_build build --config=opt --config=cuda --disk_cache=/dockerdata/cathy/bazel_cache //tensorflow/tools/pip_package:build_pip_package
./bazel-bin/tensorflow/tools/pip_package/build_pip_package /data1/cathy/tf-source_code/tf-install/master.1114/build
echo "begin install"
sh /data1/cathy/tf-source_code/tf-install/master.1114/build/install.sh
