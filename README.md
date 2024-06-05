# matrix_multiplier
a matrix multiplier with 2 MAC in parallel, and a sparse matrix vector multiplier based on CSR format

The matrix is instansiated as a 8*8 matrix A and B with 8 bits signed value, the result C is 18 bit signed value matrix.
Here's the result of one channel MAC matrix_multiplier based on three stage pipeline which is , memory access, mac, write back.
The address fetching is based on a counter , the code is in file matrix_mux1.v
The performace is 514 clock cyclein total , which is 64*8 mac calculation, with 2 initial pipeline stage delay .

<img width="481" alt="image" src="https://github.com/taiqianguo/matrix_multiplier/assets/58079218/1971d2ec-0b7d-4dbb-8e43-6918f1c71642">

Here's the result of two channel MAC matrix_multiplier based on three stage pipeline which is , memory access, mac, write back.
The address fetching is also based on a counter , the code is in file matrix_mux.v
The performace is 260 clock cyclein total , which is 32*8 mac calculation, with 2 initial pipeline stage delay , 2 write back buffer delay (casue we assume here the write back is single port)

<img width="559" alt="image" src="https://github.com/taiqianguo/matrix_multiplier/assets/58079218/433c7f61-951f-4eea-9629-59c1811034ca">

Here's the sparse matrix vector multiplier, which is wildly used , the function is S*v=d , the compression format is CSR.
[link of CSR format ](https://en.wikipedia.org/wiki/Sparse_matrix#Compressed_sparse_row_(CSR,_CRS_or_Yale_format))
The module in SpMV.v (spares matrix vector multi plier) is one channel mac, which is four stage pipeline.
First stage is to fetch row_index, S vector and column_index. 
Second stage is fetch v based on column_index which in dicate in this rwo, where is not empty and should be multiplied with element in vector.
Third stage is mac calculation, then the write back stage.

he main principle is to obtain the target address through row_index. When the self-increment address is equal to the target address, the value of the next row of the s matrix is ​​obtained. 
AS seen in simulation this four-stage pipeline. Each row has four calculations, so when clock_counter=8, macc_clear is set and the data is written to the result. The result data is datac4 and the address is addrd.

<img width="1185" alt="image" src="https://github.com/taiqianguo/matrix_multiplier/assets/58079218/d9204463-60c7-40a4-9c56-3ed84650b2e7">
