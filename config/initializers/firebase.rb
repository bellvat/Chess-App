base_uri = 'https://chess-space.firebaseio.com'
secret_key = "PppWgkxJwrQkfpByYmjxB0oPLsCjk2cgvSgmBynp"
firebase = Firebase::Client.new(base_uri, secret_key)

response = firebase.push("message", { :body => 'This is a test', :priority => 1 })
puts response.success? # => true
puts response.code # => 200
puts response.body # => { 'name' => "-INOQPH-aV_psbk3ZXEX" }
puts response.raw_body # => '{"name":"-INOQPH-aV_psbk3ZXEX"}'