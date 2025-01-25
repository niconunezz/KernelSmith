from python.jit import jit
import torch
import python.language as tl

@jit
def bf(A, B):

    a = tl.load(A)
    b = a*5
    tl.store(B,b)


def test():
    A = torch.tensor((2), device = 'cuda')
    B = torch.empty((1), device= 'cuda')

    bf[(1,3)](A,B)


test()