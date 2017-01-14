module Example
=begin
  @doc (document1) Document One
  @doc_desc detail:
    This is document of number one.
    It do not anything. Just to test.
  @doc_desc
      This is the second paragraph of this document description.
    It do not anything, too.
=end
  class SubA
    prefix :api
    version :v1

    resource :a_res do
=begin
      @res get /api/v1/a_res Get list of A
      @res_desc
        This resource can get list of A. It can paginate.
      @res_desc see more:
            This is the second paragraph of this resource description.
        Can not have more describe.

      @res_param {Boolean} is A boolean value
        More description
      @res_param_section
        Very very much
      @res_param {Number} num=0 A Number value
      @res_param {String=a,b,c} str Allowed values

      @res_param {Number} [num_a] A Number value
      @res_param {Number} [num_b] A Number value, too.
      @res_param {Number} [num_c] A Number value, again.
      @res_param_bind least num_a,num_b,num_c 1

      @res_param {Number} [num_x] Number X
      @res_param {Number} [num_y] Number Y
      @res_param {Number} [num_z=3] Number Z
      @res_param_bind only num_a,num_b,num_c 2

      @res_param {String} [str_a] A String value
      @res_param {String} [str_b] A String value, too.
      @res_param {String} [str_c] A String value, again.
      @res_param_bind given str_a str_b,str_c

      @res_param {String[]} [str_x] X
      @res_param {String} [str_y] Y
      @res_param {String} [str_z] Z
      @res_param_bind entire str_x,str_y,str_z

      @res_param (group1) {Object} obj An Object value
      @res_param (group1) {String} obj.name name of Object
      @res_param (group1) {Number} [obj.count] count of Object

      @res_param (group2) {Object[]} obj An Array value
      @res_param (group2) {Boolean} obj.ok ok?
      @res_param (group2) {Number} [obj.sum] sum
=end
      get do

      end
    end
  end

=begin
  @doc (document2) Document One
  @doc_desc
This is document of number two
=end
  class SubB
    prefix :api
    version :v2
    # resource :comment

    resource :b_res do
=begin
  @res post /api/v2/b_res Get list of A
=end
      post do

      end
    end
  end

=begin
  @doc other_document
=end
  class Other

  end
end
