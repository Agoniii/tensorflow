// RUN: tf-opt %s -split-input-file -verify-diagnostics -tf-tpu-rewrite -tpu_compile_metadata_debug | FileCheck %s --dump-input=fail

// Tests `tf_device.launch_func` with missing `num_replicas` attribute.

func @missing_num_replicas() {
  // expected-error@+1 {{requires attribute 'num_replicas'}}
  "tf_device.launch_func"() {_tpu_replicate = "cluster0", device = "tpu0", func = @empty_func, num_cores_per_replica = 1, step_marker_location = "STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP", padding_map = []} : () -> ()
  return
}
func @empty_func() {
  return
}

// -----

// Tests `tf_device.launch_func` with bad `num_replicas` attribute.

func @bad_num_replicas() {
  // expected-error@+1 {{requires attribute 'num_replicas'}}
  "tf_device.launch_func"() {_tpu_replicate = "cluster0", device = "tpu0", func = @empty_func, num_replicas = "", num_cores_per_replica = 1, step_marker_location = "STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP", padding_map = []} : () -> ()
  return
}
func @empty_func() {
  return
}

// -----

// Tests `tf_device.launch_func` with missing `num_cores_per_replicas` attribute.

func @missing_num_cores_per_replica() {
  // expected-error@+1 {{requires attribute 'num_cores_per_replica'}}
  "tf_device.launch_func"() {_tpu_replicate = "cluster0", device = "tpu0", func = @empty_func, num_replicas = 1, step_marker_location = "STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP", padding_map = []} : () -> ()
  return
}
func @empty_func() {
  return
}

// -----

// Tests `tf_device.launch_func` with bad `num_cores_per_replicas` attribute.

func @bad_num_cores_per_replica() {
  // expected-error@+1 {{requires attribute 'num_cores_per_replica'}}
  "tf_device.launch_func"() {_tpu_replicate = "cluster0", device = "tpu0", func = @empty_func, num_replicas = 1, num_cores_per_replica = "", step_marker_location = "STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP", padding_map = []} : () -> ()
  return
}
func @empty_func() {
  return
}

// -----

// Tests `tf_device.launch_func` with missing `step_marker_location` attribute.

func @bad_num_cores_per_replica() {
  // expected-error@+1 {{requires attribute 'step_marker_location'}}
  "tf_device.launch_func"() {_tpu_replicate = "cluster0", device = "tpu0", func = @empty_func, num_replicas = 1, num_cores_per_replica = 1, padding_map = []} : () -> ()
  return
}
func @empty_func() {
  return
}

// -----

// Tests `tf_device.launch_func` with bad `step_marker_location` attribute.

func @bad_step_marker_location() {
  // expected-error@+1 {{requires attribute 'step_marker_location'}}
  "tf_device.launch_func"() {_tpu_replicate = "cluster0", device = "tpu0", func = @empty_func, num_replicas = 1, num_cores_per_replica = 1, step_marker_location = 1, padding_map = []} : () -> ()
  return
}
func @empty_func() {
  return
}

// -----

// Tests `tf_device.launch_func` with unparsable `step_marker_location` attribute.

func @unparsable_step_marker_location() {
  // expected-error@+1 {{bad 'step_marker_location' attribute with value 'test'}}
  "tf_device.launch_func"() {_tpu_replicate = "cluster0", device = "tpu0", func = @empty_func, num_replicas = 1, num_cores_per_replica = 1, step_marker_location = "test", padding_map = []} : () -> ()
  return
}
func @empty_func() {
  return
}

// -----

// Tests `tf_device.launch_func` with missing `padding_map` attribute.

func @missing_padding_map() {
  // expected-error@+1 {{requires attribute 'padding_map'}}
  "tf_device.launch_func"() {_tpu_replicate = "cluster0", device = "tpu0", func = @empty_func, num_replicas = 1, num_cores_per_replica = 1, step_marker_location = "STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP"} : () -> ()
  return
}
func @empty_func() {
  return
}

// -----

// Tests `tf_device.launch_func` with bad `padding_map` attribute.

func @bad_padding_map() {
  // expected-error@+1 {{requires attribute 'padding_map'}}
  "tf_device.launch_func"() {_tpu_replicate = "cluster0", device = "tpu0", func = @empty_func, num_replicas = 1, num_cores_per_replica = 1, step_marker_location = "STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP", padding_map = ""} : () -> ()
  return
}
func @empty_func() {
  return
}

// -----

// Tests `tf_device.launch_func` with bad element in `padding_map` attribute.

func @bad_element_padding_map() {
  // expected-error@+1 {{bad 'padding_map' attribute at index 0, not a string}}
  "tf_device.launch_func"() {_tpu_replicate = "cluster0", device = "tpu0", func = @empty_func, num_replicas = 1, num_cores_per_replica = 1, step_marker_location = "STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP", padding_map = [1]} : () -> ()
  return
}
func @empty_func() {
  return
}

// -----

// Tests `tf_device.launch_func` with unparsable element in `padding_map` attribute.

func @unparsable_element_padding_map() {
  // expected-error@+1 {{bad 'padding_map' attribute at index 0 with value 'test'}}
  "tf_device.launch_func"() {_tpu_replicate = "cluster0", device = "tpu0", func = @empty_func, num_replicas = 1, num_cores_per_replica = 1, step_marker_location = "STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP", padding_map = ["test"]} : () -> ()
  return
}
func @empty_func() {
  return
}

// -----

// Tests `tf_device.launch_func` with unsupported operand type.

func @unsupported_operand_type(%arg0: tensor<?xi2>) {
  // expected-error@+1 {{failed to determine operand type at index 0: Converting i2 to DataType}}
  %0 = "tf_device.launch_func"(%arg0) {_tpu_replicate = "cluster0", device = "tpu0", func = @empty_func, num_replicas = 1, num_cores_per_replica = 1, step_marker_location = "STEP_MARK_AT_ENTRY", padding_map = []} : (tensor<?xi2>) -> tensor<?xi2>
  return
}
func @empty_func(%arg0: tensor<?xi2>) -> tensor<?xi2> {
  return %arg0 : tensor<?xi2>
}

// -----

// Tests `tf_device.launch_func` with empty `step_marker_location` attribute
// defaults to `STEP_MARK_AT_ENTRY`.
//
// The expected TPUCompileMetadataProto is:
//   num_replicas: 1
//   num_cores_per_replica: 1

// CHECK-LABEL: func @default_step_marker_location
func @default_step_marker_location() {
  "tf_device.launch_func"() {_tpu_replicate = "cluster0", device = "tpu0", func = @empty_func, num_replicas = 1, num_cores_per_replica = 1, step_marker_location = "", padding_map = []} : () -> ()
  // CHECK:      metadata
  // CHECK-SAME: num_replicas: 1
  // CHECK-SAME: num_cores_per_replica: 1
  return
}
func @empty_func() {
  return
}

// -----

// The following padding map is used in subsequent test cases:
// Proto debug string:
//   arg_index: 1
//   shape_index: 2
//   padding_arg_index: 3
// Serialized string:
//   "\08\01\10\02\18\03"

// -----

// Tests metadata is populated correctly based on launch_func op and attributes.
//
// The expected TPUCompileMetadataProto is:
//   args {
//     dtype: DT_INT32
//     kind: PARAMETER
//     sharding {
//       type: MAXIMAL
//       tile_assignment_dimensions: 1
//       tile_assignment_devices: 0
//     }
//   }
//   retvals {
//     sharding {
//       type: MAXIMAL
//       tile_assignment_dimensions: 1
//       tile_assignment_devices: 0
//     }
//   }
//   num_replicas: 1
//   num_cores_per_replica: 1
//   padding_maps {
//     arg_index: 1
//     shape_index: 2
//     padding_arg_index: 3
//   }
//   step_marker_location: STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP

// CHECK-LABEL: func @metadata
func @metadata(%arg0: tensor<?xi32>) -> tensor<?xi32> {
  %0 = "tf_device.launch_func"(%arg0) {_tpu_replicate = "cluster0", device = "tpu0", func = @tpu0_func, num_replicas = 1, num_cores_per_replica = 1, step_marker_location = "STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP", padding_map = ["\08\01\10\02\18\03"]} : (tensor<?xi32>) -> tensor<?xi32>
  // CHECK:      metadata
  // CHECK-SAME: args
  // CHECK-SAME: dtype: DT_INT32
  // CHECK-SAME: kind: PARAMETER
  // CHECK-SAME: sharding
  // CHECK-SAME: type: MAXIMAL
  // CHECK-SAME: tile_assignment_dimensions: 1
  // CHECK-SAME: tile_assignment_devices: 0
  // CHECK-SAME: retvals
  // CHECK-SAME: sharding
  // CHECK-SAME: type: MAXIMAL
  // CHECK-SAME: tile_assignment_dimensions: 1
  // CHECK-SAME: tile_assignment_devices: 0
  // CHECK-SAME: num_replicas: 1
  // CHECK-SAME: num_cores_per_replica: 1
  // CHECK-SAME: padding_maps
  // CHECK-SAME: arg_index: 1
  // CHECK-SAME: shape_index: 2
  // CHECK-SAME: padding_arg_index: 3
  // CHECK-SAME: step_marker_location: STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP

  return %0: tensor<?xi32>
}
func @tpu0_func(%arg0: tensor<?xi32>) -> tensor<?xi32> {
  return %arg0 : tensor<?xi32>
}

// -----

// Tests simple case of `tf_device.launch_func` on TPU with single input and
// single output.

module {
  // CHECK-LABEL: func @single_tpu_launch_func
  func @single_tpu_launch_func(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.A"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[A_OUTPUT:[0-9]*]] = "tf.A"

    %1 = "tf_device.launch_func"(%0) {_tpu_replicate = "cluster0", device = "tpu0", func = @tpu0_func, num_replicas = 1, num_cores_per_replica = 1, step_marker_location = "STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP", padding_map = ["\08\01\10\02\18\03"]} : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[A_SHAPE_OUTPUT:[0-9]*]] = "tf.Shape"(%[[A_OUTPUT]])
    // CHECK: %[[COMPILE_OUTPUT:[0-9]*]]:2 = "tf._TPUCompileMlir"(%[[A_SHAPE_OUTPUT]])
    // CHECK-SAME: NumDynamicShapes = 1
    // CHECK-SAME: metadata
    // CHECK-SAME: mlir_module
    // CHECK-SAME: func @main
    // CHECK-SAME: tf.B
    // CHECK-NOT: func = @tpu0_func
    // CHECK: %[[EXECUTE_OUTPUT:[0-9]*]] = "tf.TPUExecute"(%[[A_OUTPUT]], %[[COMPILE_OUTPUT]]#1)
    // CHECK-SAME: Targs = [tensor<?xi32>]
    // CHECK-SAME: Tresults = [tensor<?xi32>]

    %2 = "tf.C"(%1) : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[C_OUTPUT:[0-9]*]] = "tf.C"(%[[EXECUTE_OUTPUT]])

    return %2 : tensor<?xi32>
    // CHECK: return %[[C_OUTPUT]]
  }

  func @tpu0_func(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.B"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    return %0 : tensor<?xi32>
  }
}

// -----

// Tests that launch_func without _tpu_replicate attribute is ignored.

module {
  // CHECK-LABEL: func @single_gpu_launch_func
  func @single_gpu_launch_func(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.A"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>

    %1 = "tf_device.launch_func"(%0) {device = "gpu0", func = @gpu0_func, num_replicas = 1, num_cores_per_replica = 1, step_marker_location = "STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP", padding_map = ["\08\01\10\02\18\03"]} : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: tf_device.launch_func
    // CHECK-SAME: device = "gpu0"
    // CHECK-SAME: func = @gpu0_func
    // CHECK-SAME: num_cores_per_replica = 1
    // CHECK-SAME: num_replicas = 1
    // CHECK-SAME: padding_map = ["\08\01\10\02\18\03"]
    // CHECK-SAME: step_marker_location = "STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP"
    // CHECK-NOT: metadata

    return %1 : tensor<?xi32>
  }

  func @gpu0_func(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.B"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    return %0 : tensor<?xi32>
  }
}

// -----

// Tests of `tf_device.launch_func` on TPU with nested function calls.

module {
  // CHECK-LABEL: func @with_nested_func
  func @with_nested_func(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.A"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[A_OUTPUT:[0-9]*]] = "tf.A"

    %1 = "tf_device.launch_func"(%0) {_tpu_replicate = "cluster0", device = "tpu0", func = @tpu0_func, num_replicas = 1, num_cores_per_replica = 1, step_marker_location = "STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP", padding_map = ["\08\01\10\02\18\03"]} : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[A_SHAPE_OUTPUT:[0-9]*]] = "tf.Shape"(%[[A_OUTPUT]])
    // CHECK: %[[COMPILE_OUTPUT:[0-9]*]]:2 = "tf._TPUCompileMlir"(%[[A_SHAPE_OUTPUT]])
    // CHECK-SAME: NumDynamicShapes = 1
    // CHECK-SAME: metadata
    // CHECK-SAME: mlir_module
    // CHECK-SAME: func @main
    // CHECK-SAME: tf.B
    // CHECK-SAME: func @nested_func
    // CHECK-SAME: tf.D
    // CHECK-NOT: func = @tpu0_func
    // CHECK: %[[EXECUTE_OUTPUT:[0-9]*]] = "tf.TPUExecute"(%[[A_OUTPUT]], %[[COMPILE_OUTPUT]]#1)
    // CHECK-SAME: Targs = [tensor<?xi32>]
    // CHECK-SAME: Tresults = [tensor<?xi32>]

    %2 = "tf.C"(%1) : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[C_OUTPUT:[0-9]*]] = "tf.C"(%[[EXECUTE_OUTPUT]])

    return %2 : tensor<?xi32>
    // CHECK: return %[[C_OUTPUT]]
  }

  func @tpu0_func(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.B"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    %1 = call @nested_func(%0) : (tensor<?xi32>) -> tensor<?xi32>
    return %1 : tensor<?xi32>
  }

  func @nested_func(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.D"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    return %0 : tensor<?xi32>
  }
}

// -----

// Tests of `tf_device.launch_func` on TPU with referenced function that's not
// via a standard call op.

module {
  // CHECK-LABEL: func @with_referenced_func
  func @with_referenced_func(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.A"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[A_OUTPUT:[0-9]*]] = "tf.A"

    %1 = "tf_device.launch_func"(%0) {_tpu_replicate = "cluster0", device = "tpu0", func = @tpu0_func, num_replicas = 1, num_cores_per_replica = 1, step_marker_location = "STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP", padding_map = ["\08\01\10\02\18\03"]} : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[A_SHAPE_OUTPUT:[0-9]*]] = "tf.Shape"(%[[A_OUTPUT]])
    // CHECK: %[[COMPILE_OUTPUT:[0-9]*]]:2 = "tf._TPUCompileMlir"(%[[A_SHAPE_OUTPUT]])
    // CHECK-SAME: NumDynamicShapes = 1
    // CHECK-SAME: metadata
    // CHECK-SAME: mlir_module
    // CHECK-SAME: func @main
    // CHECK-SAME: tf.B
    // CHECK-SAME: func @referenced_func
    // CHECK-SAME: tf.D
    // CHECK-NOT: func = @tpu0_func
    // CHECK: %[[EXECUTE_OUTPUT:[0-9]*]] = "tf.TPUExecute"(%[[A_OUTPUT]], %[[COMPILE_OUTPUT]]#1)
    // CHECK-SAME: Targs = [tensor<?xi32>]
    // CHECK-SAME: Tresults = [tensor<?xi32>]

    %2 = "tf.C"(%1) : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[C_OUTPUT:[0-9]*]] = "tf.C"(%[[EXECUTE_OUTPUT]])

    return %2 : tensor<?xi32>
    // CHECK: return %[[C_OUTPUT]]
  }

  func @tpu0_func(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.B"(%arg0) {body = @referenced_func} : (tensor<?xi32>) -> tensor<?xi32>
    return %0 : tensor<?xi32>
  }

  func @referenced_func(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.D"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    return %0 : tensor<?xi32>
  }
}

// -----

// Tests rewriting `tf_device.launch_func` on TPU with a chain of referenced
// functions.

module {
  // CHECK-LABEL: func @with_referenced_func_chain
  func @with_referenced_func_chain(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.A"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[A_OUTPUT:[0-9]*]] = "tf.A"

    %1 = "tf_device.launch_func"(%0) {_tpu_replicate = "cluster0", device = "tpu0", func = @tpu0_func, num_replicas = 1, num_cores_per_replica = 1, step_marker_location = "STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP", padding_map = ["\08\01\10\02\18\03"]} : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[A_SHAPE_OUTPUT:[0-9]*]] = "tf.Shape"(%[[A_OUTPUT]])
    // CHECK: %[[COMPILE_OUTPUT:[0-9]*]]:2 = "tf._TPUCompileMlir"(%[[A_SHAPE_OUTPUT]])
    // CHECK-SAME: NumDynamicShapes = 1
    // CHECK-SAME: metadata
    // CHECK-SAME: mlir_module
    // CHECK-SAME: func @main
    // CHECK-SAME: tf.B
    // CHECK-SAME: @referenced_func1
    // CHECK-SAME: tf.D
    // CHECK-SAME: @referenced_func2
    // CHECK-SAME: tf.E
    // CHECK-NOT: func = @tpu0_func
    // CHECK: %[[EXECUTE_OUTPUT:[0-9]*]] = "tf.TPUExecute"(%[[A_OUTPUT]], %[[COMPILE_OUTPUT]]#1)
    // CHECK-SAME: Targs = [tensor<?xi32>]
    // CHECK-SAME: Tresults = [tensor<?xi32>]

    %2 = "tf.C"(%1) : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[C_OUTPUT:[0-9]*]] = "tf.C"(%[[EXECUTE_OUTPUT]])

    return %2 : tensor<?xi32>
    // CHECK: return %[[C_OUTPUT]]
  }

  func @tpu0_func(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.B"(%arg0) {body = @referenced_func1} : (tensor<?xi32>) -> tensor<?xi32>
    return %0 : tensor<?xi32>
  }

  func @referenced_func1(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.D"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    %1 = call @referenced_func2(%0) : (tensor<?xi32>) -> tensor<?xi32>
    return %1 : tensor<?xi32>
  }

  func @referenced_func2(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.E"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    return %0 : tensor<?xi32>
  }
}

// -----

// Tests rewriting `tf_device.launch_func` on TPU with multiple calls to same
// function.

module {
  // CHECK-LABEL: func @with_multiple_call_same_referenced_func
  func @with_multiple_call_same_referenced_func(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.A"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[A_OUTPUT:[0-9]*]] = "tf.A"

    %1 = "tf_device.launch_func"(%0) {_tpu_replicate = "cluster0", device = "tpu0", func = @tpu0_func, num_replicas = 1, num_cores_per_replica = 1, step_marker_location = "STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP", padding_map = ["\08\01\10\02\18\03"]} : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[A_SHAPE_OUTPUT:[0-9]*]] = "tf.Shape"(%[[A_OUTPUT]])
    // CHECK: %[[COMPILE_OUTPUT:[0-9]*]]:2 = "tf._TPUCompileMlir"(%[[A_SHAPE_OUTPUT]])
    // CHECK-SAME: NumDynamicShapes = 1
    // CHECK-SAME: metadata
    // CHECK-SAME: mlir_module
    // CHECK-SAME: func @main
    // CHECK-SAME: tf.B
    // CHECK-COUNT-2: call @referenced_func
    // CHECK-COUNT-1: func @referenced_func
    // CHECK-SAME: tf.D
    // CHECK-NOT: func = @tpu0_func
    // CHECK: %[[EXECUTE_OUTPUT:[0-9]*]] = "tf.TPUExecute"(%[[A_OUTPUT]], %[[COMPILE_OUTPUT]]#1)
    // CHECK-SAME: Targs = [tensor<?xi32>]
    // CHECK-SAME: Tresults = [tensor<?xi32>]

    %2 = "tf.C"(%1) : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[C_OUTPUT:[0-9]*]] = "tf.C"(%[[EXECUTE_OUTPUT]])

    return %2 : tensor<?xi32>
    // CHECK: return %[[C_OUTPUT]]
  }

  func @tpu0_func(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.B"(%arg0) {body = @referenced_func1} : (tensor<?xi32>) -> tensor<?xi32>
    %1 = call @referenced_func(%0) : (tensor<?xi32>) -> tensor<?xi32>
    %2 = call @referenced_func(%1) : (tensor<?xi32>) -> tensor<?xi32>
    return %2 : tensor<?xi32>
  }

  func @referenced_func(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %1 = "tf.D"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    return %1 : tensor<?xi32>
  }
}

// -----

// Tests multiple `tf_device.launch_func` on TPU with different computation.

module {
  // CHECK-LABEL: func @multiple_launch_different_func
  func @multiple_launch_different_func(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.A"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[A_OUTPUT:[0-9]*]] = "tf.A"

    %1 = "tf_device.launch_func"(%0) {_tpu_replicate = "cluster0", device = "tpu0", func = @tpu0_func0, num_replicas = 1, num_cores_per_replica = 1, step_marker_location = "STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP", padding_map = ["\08\01\10\02\18\03"]} : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[A_SHAPE_OUTPUT:[0-9]*]] = "tf.Shape"(%[[A_OUTPUT]])
    // CHECK: %[[COMPILE0_OUTPUT:[0-9]*]]:2 = "tf._TPUCompileMlir"(%[[A_SHAPE_OUTPUT]])
    // CHECK-SAME: NumDynamicShapes = 1
    // CHECK-SAME: metadata
    // CHECK-SAME: mlir_module
    // CHECK-SAME: func @main
    // CHECK-SAME: tf.B
    // CHECK-NOT: func = @tpu0_func0
    // CHECK: %[[EXECUTE0_OUTPUT:[0-9]*]] = "tf.TPUExecute"(%[[A_OUTPUT]], %[[COMPILE0_OUTPUT]]#1)
    // CHECK-SAME: Targs = [tensor<?xi32>]
    // CHECK-SAME: Tresults = [tensor<?xi32>]

    %2 = "tf_device.launch_func"(%1) {_tpu_replicate = "cluster1", device = "tpu0", func = @tpu0_func1, num_replicas = 1, num_cores_per_replica = 1, step_marker_location = "STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP", padding_map = ["\08\01\10\02\18\03"]} : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[EXECUTE0_SHAPE_OUTPUT:[0-9]*]] = "tf.Shape"(%[[EXECUTE0_OUTPUT]])
    // CHECK: %[[COMPILE1_OUTPUT:[0-9]*]]:2 = "tf._TPUCompileMlir"(%[[EXECUTE0_SHAPE_OUTPUT]])
    // CHECK-SAME: NumDynamicShapes = 1
    // CHECK-SAME: metadata
    // CHECK-SAME: mlir_module
    // CHECK-SAME: func @main
    // CHECK-SAME: tf.D
    // CHECK-NOT: func = @tpu0_func1
    // CHECK: %[[EXECUTE1_OUTPUT:[0-9]*]] = "tf.TPUExecute"(%[[EXECUTE0_OUTPUT]], %[[COMPILE1_OUTPUT]]#1)
    // CHECK-SAME: Targs = [tensor<?xi32>]
    // CHECK-SAME: Tresults = [tensor<?xi32>]

    %3 = "tf.C"(%2) : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[C_OUTPUT:[0-9]*]] = "tf.C"(%[[EXECUTE1_OUTPUT]])

    return %3 : tensor<?xi32>
    // CHECK: return %[[C_OUTPUT]]
  }

  func @tpu0_func0(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.B"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    return %0 : tensor<?xi32>
  }

  func @tpu0_func1(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.D"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    return %0 : tensor<?xi32>
  }
}

// -----

// Tests multiple `tf_device.launch_func` on TPU with same computation.

module {
  // CHECK-LABEL: func @multiple_launch_same_func
  func @multiple_launch_same_func(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.A"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[A_OUTPUT:[0-9]*]] = "tf.A"

    %1 = "tf_device.launch_func"(%0) {_tpu_replicate = "cluster0", device = "tpu0", func = @tpu0_func, num_replicas = 1, num_cores_per_replica = 1, step_marker_location = "STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP", padding_map = ["\08\01\10\02\18\03"]} : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[A_SHAPE_OUTPUT:[0-9]*]] = "tf.Shape"(%[[A_OUTPUT]])
    // CHECK: %[[COMPILE0_OUTPUT:[0-9]*]]:2 = "tf._TPUCompileMlir"(%[[A_SHAPE_OUTPUT]])
    // CHECK-SAME: NumDynamicShapes = 1
    // CHECK-SAME: metadata
    // CHECK-SAME: mlir_module
    // CHECK-SAME: func @main
    // CHECK-SAME: tf.B
    // CHECK-NOT: func = @tpu0_func
    // CHECK: %[[EXECUTE0_OUTPUT:[0-9]*]] = "tf.TPUExecute"(%[[A_OUTPUT]], %[[COMPILE0_OUTPUT]]#1)
    // CHECK-SAME: Targs = [tensor<?xi32>]
    // CHECK-SAME: Tresults = [tensor<?xi32>]

    %2 = "tf_device.launch_func"(%1) {_tpu_replicate = "cluster1", device = "tpu0", func = @tpu0_func, num_replicas = 1, num_cores_per_replica = 1, step_marker_location = "STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP", padding_map = ["\08\01\10\02\18\03"]} : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[EXECUTE0_SHAPE_OUTPUT:[0-9]*]] = "tf.Shape"(%[[EXECUTE0_OUTPUT]])
    // CHECK: %[[COMPILE1_OUTPUT:[0-9]*]]:2 = "tf._TPUCompileMlir"(%[[EXECUTE0_SHAPE_OUTPUT]])
    // CHECK-SAME: NumDynamicShapes = 1
    // CHECK-SAME: metadata
    // CHECK-SAME: mlir_module
    // CHECK-SAME: func @main
    // CHECK-SAME: tf.B
    // CHECK-NOT: func = @tpu0_func
    // CHECK: %[[EXECUTE1_OUTPUT:[0-9]*]] = "tf.TPUExecute"(%[[EXECUTE0_OUTPUT]], %[[COMPILE1_OUTPUT]]#1)
    // CHECK-SAME: Targs = [tensor<?xi32>]
    // CHECK-SAME: Tresults = [tensor<?xi32>]

    %3 = "tf.C"(%2) : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[C_OUTPUT:[0-9]*]] = "tf.C"(%[[EXECUTE1_OUTPUT]])

    return %3 : tensor<?xi32>
    // CHECK: return %[[C_OUTPUT]]
  }

  func @tpu0_func(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.B"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    return %0 : tensor<?xi32>
  }
}

// -----

// Tests Functions referenced by TPU function via SymbolRefAttr nested in
// ArrayAttr and DictionaryAttr.

module {
  // CHECK-LABEL: func @single_tpu_launch_func
  func @single_tpu_launch_func(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.A"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[A_OUTPUT:[0-9]*]] = "tf.A"

    %1 = "tf_device.launch_func"(%0) {_tpu_replicate = "cluster0", device = "tpu0", func = @tpu0_func, num_replicas = 1, num_cores_per_replica = 1, step_marker_location = "STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP", padding_map = ["\08\01\10\02\18\03"]} : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[A_SHAPE_OUTPUT:[0-9]*]] = "tf.Shape"(%[[A_OUTPUT]])
    // CHECK: %[[COMPILE_OUTPUT:[0-9]*]]:2 = "tf._TPUCompileMlir"(%[[A_SHAPE_OUTPUT]])
    // CHECK-SAME: NumDynamicShapes = 1
    // CHECK-SAME: metadata
    // CHECK-SAME: mlir_module
    // CHECK-SAME: func @main
    // CHECK-SAME: tf.B
    // CHECK-SAME: func @referenced_func2
    // CHECK-SAME: tf.H
    // CHECK-SAME: func @referenced_func3
    // CHECK-SAME: tf.I
    // CHECK-SAME: func @referenced_func0
    // CHECK-SAME: tf.F
    // CHECK-SAME: func @referenced_func1
    // CHECK-SAME: tf.G
    // CHECK: %[[EXECUTE_OUTPUT:[0-9]*]] = "tf.TPUExecute"(%[[A_OUTPUT]], %[[COMPILE_OUTPUT]]#1)
    // CHECK-SAME: Targs = [tensor<?xi32>]
    // CHECK-SAME: Tresults = [tensor<?xi32>]

    %2 = "tf.C"(%1) : (tensor<?xi32>) -> tensor<?xi32>
    // CHECK: %[[C_OUTPUT:[0-9]*]] = "tf.C"(%[[EXECUTE_OUTPUT]])

    return %2 : tensor<?xi32>
    // CHECK: return %[[C_OUTPUT]]
  }

  func @tpu0_func(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %0 = "tf.B"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    %1 = "tf.D"(%0) {array_attr_funcs = [@referenced_func0, @referenced_func1]} : (tensor<?xi32>) -> tensor<?xi32>
    %2 = "tf.E"(%1) {dictionary_attr_funcs = {fn1 = @referenced_func2, fn2 = @referenced_func3}} : (tensor<?xi32>) -> tensor<?xi32>
    return %0 : tensor<?xi32>
  }

  func @referenced_func0(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %1 = "tf.F"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    return %1 : tensor<?xi32>
  }

  func @referenced_func1(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %1 = "tf.G"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    return %1 : tensor<?xi32>
  }

  func @referenced_func2(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %1 = "tf.H"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    return %1 : tensor<?xi32>
  }

  func @referenced_func3(%arg0: tensor<?xi32>) -> tensor<?xi32> {
    %1 = "tf.I"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
    return %1 : tensor<?xi32>
  }
}


// -----


// Tests that TPUCompilationResult operations are properly rewritten

// CHECK-LABEL: func @tpu_compilation_result
func @tpu_compilation_result(%arg0: tensor<?xi32>) -> (tensor<?xi32>, tensor<!tf.string>, tensor<!tf.string>) {

  // CHECK: %[[COMPILE_OUTPUT:[0-9]*]]:2 = "tf._TPUCompileMlir"
  // CHECK: %[[EXECUTE_OUTPUT:[0-9]*]] = "tf.TPUExecute"
  %1 = "tf_device.launch_func"(%arg0) {_tpu_replicate = "cluster0", device = "tpu0", func = @tpu0_func, num_replicas = 1, num_cores_per_replica = 1, step_marker_location = "", padding_map = []} : (tensor<?xi32>) -> tensor<?xi32>

  %compile_result = "tf.TPUCompilationResult"() {_tpu_replicate = "cluster0"} : () -> tensor<!tf.string>
  %compile_result2 = "tf.TPUCompilationResult"() {_tpu_replicate = "cluster0"} : () -> tensor<!tf.string>

  // CHECK: return %[[EXECUTE_OUTPUT]], %[[COMPILE_OUTPUT]]#0, %[[COMPILE_OUTPUT]]#0
  return %1, %compile_result, %compile_result2 : tensor<?xi32>, tensor<!tf.string>, tensor<!tf.string>
}

func @tpu0_func(%arg0: tensor<?xi32>) -> tensor<?xi32> {
  %0 = "tf.B"(%arg0) : (tensor<?xi32>) -> tensor<?xi32>
  return %0 : tensor<?xi32>
}


// -----

// Tests that TPUReplicatedInput and TPUReplicatedOutput operations are properly rewritten

func @main(%arg0 : tensor<0xf32>, %arg1 : tensor<0xf32>) -> tensor<0xf32> {
  // CHECK: %[[EXECUTE_OUTPUT:[0-9]*]] = "tf.TPUExecute"(%arg0, %arg1
  %0 = "tf.TPUReplicatedInput"(%arg0) {N = 1 : i64} : (tensor<0xf32>) -> tensor<0xf32>
  %1 = "tf.TPUReplicatedInput"(%arg1) {N = 1 : i64} : (tensor<0xf32>) -> tensor<0xf32>
  %2 = "tf_device.launch_func"(%0, %1) {device = "", _tpu_replicate = "cluster", func = @_func, num_replicas = 1, num_cores_per_replica = 1, step_marker_location = "", padding_map = []} : (tensor<0xf32>, tensor<0xf32>) -> tensor<0xf32>
  %3 = "tf.TPUReplicatedOutput"(%2) {num_replicas = 1 : i64} : (tensor<0xf32>) -> tensor<0xf32>
  return %3 : tensor<0xf32>
}
func @_func(%arg0: tensor<0xf32>, %arg1: tensor<0xf32>) -> tensor<0xf32> {
  %0 = "tf.Const"() {value = dense<3.000000e+00> : tensor<0xf32>} : () -> tensor<0xf32>
  return %0 : tensor<0xf32>
}
