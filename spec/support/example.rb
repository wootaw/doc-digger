module Example
=begin
  @doc (document1) Document One
    This row is a description of this document.
    Detail:

    This is document of number one.
    It do not anything. Just to test.


      This is the second paragraph of this document description.
    It do not anything, too.
=end
  class SubA
    prefix :api
    version :v1

    resource :a_res do
=begin
      @res get /api/v1/a_res Get list of A
        This resource can get list of A. It can paginate.

        see more:

            This is the second paragraph of this resource description.
        Can not have more describe.

      @res_param {Boolean} is A boolean value
        More description
      @res_param_section
        Very very much
      @res_param {Number} [num=0] A Number value
      @res_param {String=a,b,c} str Allowed values

      @res_param {Number} [num_a] A Number value
      @res_param {Number} [num_b] A Number value, too.
      @res_param {Number} [num_c] A Number value, again.
      @res_bind (param) least num_a,num_b,num_c 1

      @res_param {Number} [num_x] Number X
      @res_param {Number} [num_y] Number Y
      @res_param {Number} [num_z=3] Number Z
      @res_bind only num_a,num_b,num_c 2

      @res_param {String} [str_a] A String value
      @res_param {String} [str_b] A String value, too.
      @res_param {String} [str_c] A String value, again.
      @res_bind (param) given str_a str_b,str_c

      @res_param {String[]} [str_x] X
      @res_param {String} [str_y] Y
      @res_param [z] Z
      @res_bind entire str_x,str_y,z

      @res_param (group1) {Object} obj An Object value
      @res_param (group1) {String} obj.name name of Object
      @res_param (group1) {Number} [obj.count=0] count of Object

      @res_param (group2) {Object[]} data An Array value
      @res_param (group2) {Boolean} data.ok ok?
      @res_param (group2) {Number[]=2,3,4} [data.sum] Sum
=end
      get do

      end

=begin
      @res post /api/v1/a_res Create an A resource
      @res_state coming Coming Soon
        This resource is not finish

      @res_header [a] A
      @res_header {String=a,b,c} b B
      @res_header {Number[]=1,2,3} c C
        More description about header C.
        Can't write more, really

      @res_header (group1) {Object} obj An Object value
      @res_header (group1) {String} obj.name name of Object
      @res_header (group1) {Number} [obj.count=0] count of Object

      @res_param {Boolean} ok A boolean value

      @res_response (group1) [a] A
      @res_response (group1) {String=a,b,c} b B
        This is the first row.
        This is the second row.
        ```ruby
          b = "a"
          if b == "a"
            puts "Ha Ha Ha"
          end
        ```
        This is the tail.
        This is the last row.
      @res_response {Number[]=1,2,3} c C
        More description about response C.
        Can't write more about response C.

      @res_response (Error) code Error code
        - 100 Message number one
        - 101 Message number two
        - 102 Message number three
        This is the last row.
      @res_response (Error) msg Error message
        This is a row detail,
        See more:
        - Message one
          1. First row
          2. Second row
          3. Third row
        - Message two
        This is the error description tail.
        This is the last row.
=end
      post do

      end
    end
  end

=begin
  @doc (document2) Document One
    This is document of number two
=end
  class SubB
    prefix :api
    version :v2
    # resource :comment

    resource :b_res do
=begin
      @res post /api/v2/b_res Get list of A
      @res_state coming This resource will be coming soon
        The first row description of resource state
        The second row description of resource state.

        The third row description of resource state
=end
      post do

      end
    end
  end

=begin
  @doc Other Document
  @doc_state deprecated
  The first row description of document state.

  The second row description of document state.
  The third row description of document state
=end
  class Other

  end
end
