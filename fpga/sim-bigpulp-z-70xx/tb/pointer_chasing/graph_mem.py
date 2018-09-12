#!/usr/bin/env python3

import re

TB_L3_BASE      = 0x44000000
PULP_L3_BASE    = 0x80000000
DATA_1_SIZE_B   = 0x40
DATA_2_SIZE_B   = 0x40
VERTEX_SIZE_B   = 3*4 + DATA_1_SIZE_B + DATA_2_SIZE_B

class Graph:
    def __init__(self):
        self.vertices = []

    def add(self, v):
        self.vertices += [v]

class Vertex:
    def __init__(self, id, addr):
        self.id = id
        self.addr = addr
        self.succs_addr = None
        self.succs = []

    def add_succ(self, addr):
        self.succs += [addr]

    def n_succs(self):
        return len(self.succs)

def graph2mem(g):
    for v in g.vertices:
        pa_v_base = v.addr - PULP_L3_BASE + TB_L3_BASE
        print("pulp_write32(axi_m, 32'h{:08x}, 32'd{});".format(pa_v_base, v.id))
        print("pulp_write32(axi_m, 32'h{:08x}, 32'd{});".format(pa_v_base + 4, v.n_succs()))
        if v.n_succs() > 0:
            va_s_base = v.succs_addr
            pa_s_base = v.succs_addr - PULP_L3_BASE + TB_L3_BASE
            print("pulp_write32(axi_m, 32'h{:08x}, 32'h{:08x});".format(pa_v_base + 8, va_s_base))
            s_idx = 0
            for s in v.succs:
                pa_s_addr = pa_s_base + 4*s_idx
                print("pulp_write32(axi_m, 32'h{:08x}, 32'h{:08x});".format(pa_s_addr, s))
                s_idx += 1
        pa_v_data2 = pa_v_base + 3*4 + DATA_1_SIZE_B
        for i in range(0, int(DATA_2_SIZE_B/4)):
            print("pulp_write32(axi_m, 32'h{:08x}, 32'h{:04x}{:04x});".format(
                pa_v_data2 + 4*i, v.id, i))
        print("")


RE_VERTEX = re.compile(r".*vertex\s+(\d+)\s+@\s+0x([0-9a-f]+)", re.IGNORECASE)
RE_SUCCS = re.compile(r".*successors\s+-\s+ext_addr\s+=\s+0x([0-9a-f]+)", re.IGNORECASE)
RE_SUCC = re.compile(r".*successor\s+\d+\s+-\s+ext_addr\s+=\s+0x([0-9a-f]+)", re.IGNORECASE)

with open('graph.txt', 'r') as f:
    v = None
    g = Graph()
    for line in f:
        m = RE_VERTEX.match(line)
        if m:
            id = int(m.group(1))
            addr = int(m.group(2), 16)
            if (v):
                g.add(v)
            v = Vertex(id, addr)
            continue
        m = RE_SUCCS.match(line)
        if m and v:
            addr = int(m.group(1), 16)
            v.succs_addr = addr
            continue
        m = RE_SUCC.match(line)
        if m and v:
            addr = int(m.group(1), 16)
            # NOTE: graph.txt actually prints the DMA pattern, i.e., the successor addresses
            # correspond to where the data_2 member of the vertex struct.
            addr = addr - VERTEX_SIZE_B + DATA_1_SIZE_B
            v.add_succ(addr)
            continue

    if v:
        g.add(v)

    graph2mem(g)
