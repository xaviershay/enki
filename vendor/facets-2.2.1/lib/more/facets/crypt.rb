# TITLE:
#
#   Crypt
#
# DESCRIPTION:
#
#   A pure ruby version of crypt(3), a salted one-way hashing of a password.
#
# COPYRIGHT:
#
#   Copyright (c) 2002 Poul-Henning Kamp
#
# LICENSE:
#
#   Ruby License
#
#   This module is free software. You may use, modify, and/or redistribute this
#   software under the same terms as Ruby.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
#   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#   FOR A PARTICULAR PURPOSE.
#
# HISTORY:
#
#   Adapted by guillaume__dot__pierronnet_at__laposte__dot_net based on
#   * http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/325204/index_txt
#   which is based on FreeBSD src/lib/libcrypt/crypt.c 1.2
#   * http://www.freebsd.org/cgi/cvsweb.cgi/~checkout~/src/lib/libcrypt/crypt.c?rev=1.2&content-type=text/plain
#
#   [Original License]
#
#   "THE BEER-WARE LICENSE" (Revision 42):
#   <phk@login.dknet.dk> wrote this file.  As long as you retain this notice you
#   can do whatever you want with this stuff. If we meet some day, and you think
#   this stuff is worth it, you can buy me a beer in return.   Poul-Henning Kamp
#
# AUTHORS:
#
#   - Poul-Henning Kamp

require 'stringio'

# = Crypt(3)
#
# A pure ruby version of crypt(3), a salted one-way hashing of a password.
#
module Crypt

  ITOA64 = "./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

  # A pure ruby version of crypt(3), a salted one-way hashing of a password.
  #
  # Supported hashing algorithms are: md5, sha1, sha256, sha384, sha512, rmd160.
  #
  # Only the md5 hashing algorithm is standard and compatible with crypt(3), the others
  # are not standard.
  #
  # Automatically generate a 8-bytes salt if nil.
  #
  # Output a length hashed and salted string with size of
  # magic.size + salt.size + 23.

  def self.crypt(password, algo = :md5, salt = nil, magic='$1$')

    salt ||= generate_salt(8)

    case algo
      when :md5
        require "digest/md5"
      when :sha1
        require "digest/sha1"
      when :rmd160
        require "digest/rmd160"
      when :sha256, :sha384, :sha512
        require "digest/sha2"
    else
      raise(ArgumentError, "unknown algorithm")
    end
    digest_class = Digest.const_get(algo.to_s.upcase)

    # The password first, since that is what is most unknown. Then our magic string. Then the raw salt.
    m = digest_class.new
    m.update(password + magic + salt)

    # Then just as many characters of the MD5(pw,salt,pw)
    mixin = digest_class.new.update(password + salt + password).digest
    password.length.times do |i|
      m.update(mixin[i % 16].chr)
    end

    # Then something really weird...
    # Also really broken, as far as I can tell.  -m
    i = password.length
    while i != 0
      if (i & 1) != 0
        m.update("\x00")
      else
        m.update(password[0].chr)
      end
      i >>= 1
    end

    final = m.digest

    # and now, just to make sure things don't run too fast
    1000.times do |i|
      m2 = digest_class.new

      if (i & 1) != 0
        m2.update(password)
      else
        m2.update(final)
      end

      if (i % 3) != 0
        m2.update(salt)
      end
      if (i % 7) != 0
        m2.update(password)
      end

      if (i & 1) != 0
        m2.update(final)
      else
        m2.update(password)
      end

      final = m2.digest
    end

    # This is the bit that uses to64() in the original code.

    rearranged = ""

    [ [0, 6, 12], [1, 7, 13], [2, 8, 14], [3, 9, 15], [4, 10, 5] ].each do |a, b, c|

      v = final[a] << 16 | final[b] << 8 | final[c]

      4.times do
        rearranged += ITOA64[v & 0x3f].chr
        v >>= 6
      end
    end

    v = final[11]

    2.times do
      rearranged += ITOA64[v & 0x3f].chr
      v >>= 6
    end

    magic + salt + '$' + rearranged
  end


  # check the validity of a password against an hashed string

  def self.check(password, hash, algo = :md5)
    magic, salt = hash.split('$')[1,2]
    magic = '$' + magic + '$'
    self.crypt(password, algo, salt, magic) == hash
  end


  # generate a +size+ length random salt

  def self.generate_salt(size)
    (1..size).collect { ITOA64[rand(ITOA64.size)].chr }.join("")
  end
end


class BiCrypt

  ULONG   = 0x100000000

  def block_size
    return(8)
  end

  def initialize(userKey)

    # These are the S-boxes given in Applied Cryptography 2nd Ed., p. 333
    @sBox = [
      [4, 10, 9, 2, 13, 8, 0, 14, 6, 11, 1, 12, 7, 15, 5, 3],
      [14, 11, 4, 12, 6, 13, 15, 10, 2, 3, 8, 1, 0, 7, 5, 9],
      [5, 8, 1, 13, 10, 3, 4, 2, 14, 15, 12, 7, 6, 0, 9, 11],
      [7, 13, 10, 1, 0, 8, 9, 15, 14, 4, 6, 12, 11, 2, 5, 3],
      [6, 12, 7, 1, 5, 15, 13, 8, 4, 10, 9, 14, 0, 3, 11, 2],
      [4, 11, 10, 0, 7, 2, 1, 13, 3, 6, 8, 5, 9, 12, 15, 14],
      [13, 11, 4, 1, 3, 15, 5, 9, 0, 10, 14, 7, 6, 8, 2, 12],
      [1, 15, 13, 0, 5, 7, 10, 4, 9, 2, 3, 14, 6, 11, 8, 12]
    ]

    # These are the S-boxes given in the GOST source code listing in Applied
    # Cryptography 2nd Ed., p. 644.  They appear to be from the DES S-boxes
    # [13,  2,  8,  4,  6, 15, 11,  1, 10,  9,  3, 14,  5,  0, 12,  7 ],
    # [ 4, 11,  2, 14, 15,  0,  8, 13,  3, 12,  9,  7,  5, 10,  6,  1 ],
    # [12,  1, 10, 15,  9,  2,  6,  8,  0, 13,  3,  4, 14,  7,  5, 11 ],
    # [ 2, 12,  4,  1,  7, 10, 11,  6,  8,  5,  3, 15, 13,  0, 14,  9 ],
    # [ 7, 13, 14,  3,  0,  6,  9, 10,  1,  2,  8,  5, 11, 12,  4, 15 ],
    # [10,  0,  9, 14,  6,  3, 15,  5,  1, 13, 12,  7, 11,  4,  2,  8 ],
    # [15,  1,  8, 14,  6, 11,  3,  4,  9,  7,  2, 13, 12,  0,  5, 10 ],
    # [14,  4, 13,  1,  2, 15, 11,  8,  3, 10,  6, 12,  5,  9,  0,  7 ]

    # precalculate the S table
    @sTable = precalculate_S_table()

    # derive the 32-byte key from the user-supplied key
    userKeyLength = userKey.length
    @key = userKey[0..31].unpack('C'*32)
    if (userKeyLength < 32)
      userKeyLength.upto(31) { @key << 0 }
    end
  end


  def precalculate_S_table()
    sTable = [[], [], [], []]
    0.upto(3) { |i|
      0.upto(255) { |j|
        t = @sBox[2*i][j % 16] | (@sBox[2*i+1][j/16] << 4)
        u = (8*i + 11) % 32
        v = (t << u) | (t >> (32-u))
        sTable[i][j] = (v % ULONG)
      }
    }
    return(sTable)
  end


  def f(longWord)
    longWord = longWord % ULONG
    a, b, c, d = [longWord].pack('L').unpack('CCCC')
    return(@sTable[3][d] ^ @sTable[2][c] ^ @sTable[1][b] ^ @sTable[0][a])
  end

  def encrypt_pair(xl, xr)
    3.times {
      xr ^= f(xl+@key[0])
      xl ^= f(xr+@key[1])
      xr ^= f(xl+@key[2])
      xl ^= f(xr+@key[3])
      xr ^= f(xl+@key[4])
      xl ^= f(xr+@key[5])
      xr ^= f(xl+@key[6])
      xl ^= f(xr+@key[7])
    }
    xr ^= f(xl+@key[7])
    xl ^= f(xr+@key[6])
    xr ^= f(xl+@key[5])
    xl ^= f(xr+@key[4])
    xr ^= f(xl+@key[3])
    xl ^= f(xr+@key[2])
    xr ^= f(xl+@key[1])
    xl ^= f(xr+@key[0])
    return([xr, xl])
  end


  def decrypt_pair(xl, xr)
    xr ^= f(xl+@key[0])
    xl ^= f(xr+@key[1])
    xr ^= f(xl+@key[2])
    xl ^= f(xr+@key[3])
    xr ^= f(xl+@key[4])
    xl ^= f(xr+@key[5])
    xr ^= f(xl+@key[6])
    xl ^= f(xr+@key[7])
    3.times {
      xr ^= f(xl+@key[7])
      xl ^= f(xr+@key[6])
      xr ^= f(xl+@key[5])
      xl ^= f(xr+@key[4])
      xr ^= f(xl+@key[3])
      xl ^= f(xr+@key[2])
      xr ^= f(xl+@key[1])
      xl ^= f(xr+@key[0])
    }
    return([xr, xl])
  end

  def encrypt_block(block)
    xl, xr = block.unpack('NN')
    xl, xr = encrypt_pair(xl, xr)
    encrypted = [xl, xr].pack('NN')
    return(encrypted)
  end


  def decrypt_block(block)
    xl, xr = block.unpack('NN')
    xl, xr = decrypt_pair(xl, xr)
    decrypted = [xl, xr].pack('NN')
    return(decrypted)
  end

  # When this module is mixed in with an encryption class, the class
  # must provide three methods: encrypt_block(block) and decrypt_block(block)
  # and block_size()

  def generate_initialization_vector(words)
    srand(Time.now.to_i)
    vector = ""
    words.times {
      vector << [rand(ULONG)].pack('N')
    }
    return(vector)
  end


  def encrypt_stream(plainStream, cryptStream)
    # Cypher-block-chain mode

    initVector = generate_initialization_vector(block_size() / 4)
    chain = encrypt_block(initVector)
    cryptStream.write(chain)

    while ((block = plainStream.read(block_size())) && (block.length == block_size()))
      block = block ^ chain
      encrypted = encrypt_block(block)
      cryptStream.write(encrypted)
      chain = encrypted
    end

    # write the final block
    # At most block_size()-1 bytes can be part of the message.
    # That means the final byte can be used to store the number of meaningful
    # bytes in the final block
    block = '' if block.nil?
    buffer = block.split('')
    remainingMessageBytes = buffer.length
    # we use 7-bit characters to avoid possible strange behavior on the Mac
    remainingMessageBytes.upto(block_size()-2) { buffer << rand(128).chr }
    buffer << remainingMessageBytes.chr
    block = buffer.join('')
    block = block ^ chain
    encrypted = encrypt_block(block)
    cryptStream.write(encrypted)
  end


  def decrypt_stream(cryptStream, plainStream)
    # Cypher-block-chain mode
    chain = cryptStream.read(block_size())

    while (block = cryptStream.read(block_size()))
      decrypted = decrypt_block(block)
      plainText = decrypted ^ chain
      plainStream.write(plainText) unless cryptStream.eof?
      chain = block
    end

    # write the final block, omitting the padding
    buffer = plainText.split('')
    remainingMessageBytes = buffer.last.unpack('C').first
    remainingMessageBytes.times { plainStream.write(buffer.shift) }
  end


  def carefully_open_file(filename, mode)
    begin
      aFile = File.new(filename, mode)
    rescue
      puts "Sorry. There was a problem opening the file <#{filename}>."
      aFile.close() unless aFile.nil?
      raise
    end
    return(aFile)
  end


  def encrypt_file(plainFilename, cryptFilename)
    plainFile = carefully_open_file(plainFilename, 'rb')
    cryptFile = carefully_open_file(cryptFilename, 'wb+')
    encrypt_stream(plainFile, cryptFile)
    plainFile.close unless plainFile.closed?
    cryptFile.close unless cryptFile.closed?
  end


  def decrypt_file(cryptFilename, plainFilename)
    cryptFile = carefully_open_file(cryptFilename, 'rb')
    plainFile = carefully_open_file(plainFilename, 'wb+')
    decrypt_stream(cryptFile, plainFile)
    cryptFile.close unless cryptFile.closed?
    plainFile.close unless plainFile.closed?
  end


  def encrypt_string(plainText)
    plainStream = StringIO.new(plainText)
    cryptStream = StringIO.new('')
    encrypt_stream(plainStream, cryptStream)
    cryptText = cryptStream.string
    return(cryptText)
  end


  def decrypt_string(cryptText)
    cryptStream = StringIO.new(cryptText)
    plainStream = StringIO.new('')
    decrypt_stream(cryptStream, plainStream)
    plainText = plainStream.string
    return(plainText)
  end

end


class String

  def ^(aString)
    a = self.unpack('C'*(self.length))
    b = aString.unpack('C'*(aString.length))
    if (b.length < a.length)
      (a.length - b.length).times { b << 0 }
    end
    xor = ""
    0.upto(a.length-1) { |pos|
      x = a[pos] ^ b[pos]
      xor << x.chr()
    }
    return(xor)
  end

end
