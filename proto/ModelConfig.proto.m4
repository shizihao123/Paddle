/* Copyright (c) 2016 Baidu, Inc. All Rights Reserve.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License. */

import "ParameterConfig.proto";

package paddle;

/**
 * Various structs for the configuration of a neural network
 */
sinclude(`ModelConfigExt.proto.m4')

message ExternalConfig {
  repeated string layer_names = 1;
  repeated string input_layer_names = 2;
  repeated string output_layer_names = 3;
}

message ActivationConfig {
  // identity: f(x) = x
  // sigmoid: f(x) = 1 / (1 + exp(-x))
  // logistic: f(x) = (1 - exp(-x)) / (1+ exp(-x))
  // softmax: y_i = f(x_i) = exp(x_i) / (\sum_i exp(x_i))
  // relu: y = max(0, x)
  required string type = 1;
};

message ConvConfig {
  // filter_size = 5, says that this layer will use
  // filters of size 5x5 pixels.
  required uint32 filter_size = 1;

  // The image data dimensionality.
  // This value must be either 1, 2, 3, or a multiple of 4.
  required uint32 channels = 2;

  // stride = 1, indicates that the distance between
  // successive filter applications should be 1 pixel.
  required uint32 stride = 3;

  // padding = 4, instructs the net to implicitly
  // pad the images with a 4-pixel border of zeros.
  required uint32 padding = 4;

  // If groups = 4 together with the filters = 32 parameter,
  // they state that this convolutional layer is to have 4
  // groups of 32 filters. Each filter will connect to 8
  // input channels.
  required uint32 groups = 5;
  required uint32 filter_channels = 6;

  // The size of output feature map.
  required uint32 output_x = 7;

  // The size of input feature map.
  required uint32 img_size = 8;

  // caffe mode for output size coherence
  required bool caffe_mode = 9 [default = true];

  // if filter_size_y is set , this convolutional layer will use
  // filters of size filter_size * filter_size_y pixels.
  // if filter_size_y is not set, this convolutional layer will use
  // filters of size filter_size * filter_size
  required uint32 filter_size_y = 10;
  required uint32 padding_y = 11;
  required uint32 stride_y = 12;
}

message PoolConfig {
  // max or avg pooling
  required string pool_type = 1;
  required uint32 channels = 2;

  // Defines the size of the pooling region in
  // the x (equivalently, y) dimension.
  required uint32 size_x = 3;

  // Tell the net where in the input image to start the pooling.
  // start is deprecated now.
  optional uint32 start = 4;

  // Defines the stride size between successive pooling squares.
  required uint32 stride = 5;

  // The size of output feature map.
  required uint32 output_x = 6;

  // The size of input feature map.
  required uint32 img_size = 7;

  // padding = 4, instructs the net to implicitly
  // pad the images with a 4-pixel border of zeros.
  optional uint32 padding = 8 [default = 0];

  // if not set, use size_x
  optional uint32 size_y = 9 [default = 0];

  // if not set, use stride
  optional uint32 stride_y = 10 [default = 0];

  // if not set, use output_x
  optional uint32 output_y = 11 [default = 0];

  // if not set, use img_size
  optional uint32 img_size_y = 12 [default = 0];

  // if not set, use padding
  optional uint32 padding_y = 13 [default = 0];
}

message NormConfig {
  // rnorm or cmrnorm
  required string norm_type = 1;
  required uint32 channels = 2;

  // rnorm: this defines the size of the local regions
  // used for response normalization.
  // cmrnorm: The size parameter indicates how many
  // nearby maps to use for normalization.
  required uint32 size = 3;

  // the parameters for normalization
  // u = u / (1+scale*sum(u^2 in window))^pow
  required real scale = 4;
  required real pow = 5;

  // The size of output feature map.
  required uint32 output_x = 6;

  // The size of input feature map.
  required uint32 img_size = 7;

  // normalize with fixed window or sliding window
  // u = u / (1+scale*sum(u^2 in window))^pow
  // fixed window: shared a fixed window for each value
  // sliding window: have a different window for each value
  optional bool blocked = 8;
}

message BlockExpandConfig {
  required uint32 channels = 1;

  required uint32 stride_x = 2;
  required uint32 stride_y = 3;

  required uint32 padding_x = 4;
  required uint32 padding_y = 5;

  required uint32 block_x = 6;
  required uint32 block_y = 7;

  // The size of output feature map.
  required uint32 output_x = 8;
  required uint32 output_y = 9;

  // The size of input feature map.
  required uint32 img_size_x = 10;
  required uint32 img_size_y = 11;
}

message MaxOutConfig {
  required uint32 channels = 1;
  required uint32 groups = 2;

  // The size of input feature map.
  required uint32 img_size_x = 3;
  required uint32 img_size_y = 4;
}

message ProjectionConfig {
  required string type = 1;
  required string name = 2;
  required uint64 input_size = 3;
  required uint64 output_size = 4;

  // For ShiftProjection
  optional int32 context_start = 5;
  optional int32 context_length = 6;
  optional bool trainable_padding = 7 [default = false];

  // For convolution
  optional ConvConfig conv_conf = 8;
  optional int32 num_filters = 9;

  // For IdentityOffsetProjection
  optional uint64 offset = 11 [default = 0];
}

message OperatorConfig {
  required string type = 1;
  repeated int32 input_indices = 2;
  repeated uint64 input_sizes = 3;
  required uint64 output_size = 4;

  // For DotMulOperator
  optional real dotmul_scale = 5 [default = 1.0];

  // For ConvOperator
  optional ConvConfig conv_conf = 6;
  optional int32 num_filters = 7;
}

message BilinearInterpConfig {
  // The size of input feature map.
  optional uint32 img_size_x = 1;
  optional uint32 img_size_y = 2;
  // The size of output feature map.
  required uint32 out_size_x = 3;
  required uint32 out_size_y = 4;
  required uint32 num_channels = 5;
}

message ImageConfig {
  // The image data dimensionality.
  // This value must be either 1, 2, 3, or a multiple of 4.
  required uint32 channels = 2;

  // The size of input feature map.
  required uint32 img_size = 8;
}

message LayerInputConfig {
  required string input_layer_name = 1;
  optional string input_parameter_name = 2;
  optional ConvConfig conv_conf = 3;
  optional PoolConfig pool_conf = 4;
  optional NormConfig norm_conf = 5;
  optional ProjectionConfig proj_conf = 6;
  optional BlockExpandConfig block_expand_conf = 7;
  optional ImageConfig image_conf = 8;
  // If the input layer has multi-output.
  // Set the argument name.
  optional string input_layer_argument = 9;
  optional BilinearInterpConfig bilinear_interp_conf = 10;
  optional MaxOutConfig maxout_conf = 11;
}

message LayerConfig {
sinclude(`ModelConfigLayer.proto.m4')
  required string name = 1;
  required string type = 2;
  optional uint64 size = 3;
  //optional ActivationConfig activation = 4;
  optional string active_type = 4;
  repeated LayerInputConfig inputs = 5;
  optional string bias_parameter_name = 6;

  // This number must be a multiple of 16.
  optional uint32 num_filters = 7;

  // indicates that the biases of every filter in this layer
  // should be shared amongst all applications of that filter
  // (which is how convnets are usually trained). Setting this to
  // false will untie the biases, yielding a separate bias for
  // every location at which the filter is applied.
  optional bool shared_biases = 8 [default = false];

  // Valid values are ones that divide the area of the output
  // grid in this convolutional layer. For example if this layer
  // produces 32-channel 20x20 output grid, valid values of
  // partialSum are ones which divide 20*20 = 400.
  // I'll update this comments when confirmed
  optional uint32 partial_sum = 9;

  // for dropout
  optional real drop_rate = 10;

  // for HierarchicalSoftmaxLayer and NCELayer
  // the number of classes
  optional uint32 num_classes = 11;

  // the gpu device which the Layer's data in.
  // Only used by ParallelNeuralNetork. Ignored otherwise.
  optional int32 device = 12 [default = -1];

  // for recurrent layer. If true, the recurrence runs from the end to the beginning.
  optional bool reversed = 13 [default = false];

  // for lstmemory layer. Different types of nodes have different activation type.
  optional string active_gate_type  = 14;
  optional string active_state_type = 15;

  // For NCELayer
  // The number of random negative labels for each sample
  optional int32 num_neg_samples = 16 [default = 10];

  // For NCELayer
  // The distribution for generating the random negative labels.
  // A uniform distribution will be used if not provided
  repeated real neg_sampling_dist = 17 [packed = true];

  // For MaxLayer
  // default: output VALUE of MaxLayer. set this flag to true for output INDEX
  // INDEX will be put in Argument::value as real values.
  optional bool output_max_index = 19 [default = false];

  /// The filed number 20 have been deprecated.

  // For self-normalized estimation
  optional real softmax_selfnorm_alpha = 21 [default = 0.1];

  /// The filed numbers 22 and 23 have been deprecated.

  // for MDLstmLayer
  repeated bool directions = 24;

  // for CTCLayer
  optional bool norm_by_times = 25;

  // for CostLayers
  optional real coeff = 26 [default = 1.0];

  // for AverageLayer
  // can be set to: 'average', 'sum' or 'squarerootn'
  optional string average_strategy = 27;

  // for error clipping
  optional real error_clipping_threshold = 28 [default = 0.0];

  // for operators used by mixed layer
  repeated OperatorConfig operator_confs = 29;

  // for lambdaCost
  optional int32 NDCG_num = 30;
  optional int32 max_sort_size = 31;

  // for SlopeInterceptLayer
  optional real slope = 32;
  optional real intercept = 33;

  // for CosSimVecMatLayer and CosSimLayer
  optional real cos_scale = 34;

  // for DataNormLayer
  // can be set to: 'z-score', 'min-max' or 'decimal-scaling'
  optional string data_norm_strategy = 36;

  // for bos/eos id
  optional uint32 bos_id = 37;
  optional uint32 eos_id = 38;

  // for max id layer
  optional uint32 beam_size = 39;

  // for seqlastins layer, whether select first instead last
  optional bool select_first = 40 [default = false];

  // for seqlastins layer, AverageLayer, MaxLayer and ExpandLayer
  // can be set to: 'non-seq','seq'
  optional string trans_type = 41 [default = 'non-seq'];

  // to indicate whether selective_fc layer
  // is used in sequence generation or not
  optional bool selective_fc_pass_generation = 42 [default = false];

  // to indicate whether selective_fc layer take its last input to
  // selected several columns and only compute the multiplications
  // between the input matrices and the selected columns of
  // the parameter matrices of this layer.
  // if set false, selective_fc degrades into fc.
  optional bool has_selected_colums = 43 [default = true];

  // this parameter is for speed consideration.
  // if number of the selected columns is less than
  // sample number * selective_fc output size * selective_fc_mull_mull_ratio
  // sparse multiplication is used, otherwise, using full multiplication.
  optional real selective_fc_full_mul_ratio = 44 [default = 0.02];

  // to indicate how many threads selective_fc use to to accelate
  // the plain_mul period
  // leave empty or set to 0 to disable multi-thread accleleration
  optional uint32 selective_fc_parallel_plain_mul_thread_num = 45 [default = 0];

  // for batch normalization layer
  // if set use_global_stats true, will use the loaded mean and variance.
  optional bool use_global_stats = 46;

  // use to compute moving mean and variance.
  optional real moving_average_fraction = 47 [default = 0.9];

  // bias size
  optional uint32 bias_size = 48 [default = 0];

  // this parameter can be used as a user-defined parameter when necessary, 
  // without changing the proto file.
  // e.g., when a new layer with a user-defined parameter is implemented, 
  // it can be used to pass that parameter, without modifying the proto file.
  // string type is used for flexibility: different types can be converted
  // to string and reinterpreted in the user's own layer implementation.  
  optional string user_arg = 49;

}

message EvaluatorConfig {
  required string name = 1;
  required string type = 2;
  repeated string input_layers = 3;

  // Used by ChunkEvaluator
  optional string chunk_scheme = 4; // one of "IOB", "IOE", "IOBES"
  optional int32 num_chunk_types = 5; // number of chunk types other than "other"

  // Used by PrecisionRecallEvaluator and ClassificationErrorEvaluator
  // For multi binary labels: true if output > classification_threshold
  optional real classification_threshold = 6 [default = 0.5];
  // The positive label. -1 means average precision and recall
  optional int32 positive_label = 7 [default = -1];

  // load dict from this file
  optional string dict_file = 8;

  // dump result in this file
  optional string result_file = 9;

  // top # results for max id printer
  optional int32 num_results = 10 [default = 1];

  // whether to delimit the sequence in the seq_text_printer
  optional bool delimited = 11 [default = true];
}

message LinkConfig {
  required string layer_name = 1;
  required string link_name = 2;
  // If true, this link has sub-sequence
  optional bool has_subseq = 3 [default = false];
}

message MemoryConfig {
  required string layer_name = 1;
  required string link_name = 2;

  optional string boot_layer_name = 3;
  optional string boot_bias_parameter_name = 4;
  optional string boot_bias_active_type = 5;
  optional uint32 boot_with_const_id = 7;

  // memory is a sequence, initailized by a sequence boot layer
  optional bool is_sequence = 6 [default = false];
}

message GeneratorConfig {
  required uint32 max_num_frames = 1;
  required string eos_layer_name = 2;
  optional int32 num_results_per_sample = 3 [default = 1];

  // for beam search
  optional int32 beam_size = 4 [default = 1];

  optional bool log_prob = 5 [default = true];
}

message SubModelConfig {
  required string name = 1;
  repeated string layer_names = 2; // selected layers in sub model
  repeated string input_layer_names = 3;
  repeated string output_layer_names = 4;
  repeated string evaluator_names = 5;

  optional bool is_recurrent_layer_group = 6 [default = false];

  // If true, the recurrence runs from the end to the beginning.
  optional bool reversed = 7 [default = false];

  // name and link name of memory
  repeated MemoryConfig memories = 8;

  // if use recurrent layer group, all layers in submodel will postfix by
  // "_in_"+submodel.name, so we add a name pair to link between
  // root model and layer group,
  // note that these in/out layers are not input/output of the network.
  repeated LinkConfig in_links = 9;
  repeated LinkConfig out_links = 10;

  optional GeneratorConfig generator = 11;

  // the id of inlink which share info with outlinks, used in recurrent layer group
  optional int32 target_inlinkid = 12;
}

message ModelConfig {
  // type of the model.
  // Currently, "nn", "recurrent_nn" and "recursive_nn" are supported
  required string type = 1 [default = "nn"];

  // layers should be ordered in such a way that the forward propagation
  // can be correctly executed by going from the first layer to the last layer
  repeated LayerConfig layers = 2;

  repeated ParameterConfig parameters = 3;

  // Input layers should have the same order as the data streams provided
  // by the data provider. The type of input layers should be "data"
  repeated string input_layer_names = 4;

  // For training, the type of a output layer is usually cost layer.
  // For prediction, they should be the actual output layers.
  repeated string output_layer_names = 5;

  repeated EvaluatorConfig evaluators = 6;

  repeated SubModelConfig sub_models = 8;

  // For External Machine, defining how to split a neural network
  // into multiple parts.
  optional ExternalConfig external_config = 9;
};
