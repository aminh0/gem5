import m5
from m5.objects import *
from caches import *
import argparse

parser = argparse.ArgumentParser(description='A simple system with 2-level cache.')
parser.add_argument("binary", default="", nargs="?", type=str,
                    help="Path to the binary to execute.")
parser.add_argument("--l1i_size",
                    help="L1 instruction cache size. Default: 16kB.")
parser.add_argument("--l1d_size",
                    help="L1 data cache size. Default: 64kB.")
parser.add_argument("--l2_size",
                    help="L2 cache size. Default: 256kB.")

options = parser.parse_args()

# 시뮬레이션할 시스템 생성
system = System()

# 클럭 도메인 설정 (1GHz)
system.clk_domain = SrcClockDomain()
system.clk_domain.clock = '1GHz'
system.clk_domain.voltage_domain = VoltageDomain()

# 메모리 모드 및 크기 설정
system.mem_mode = 'timing'
system.mem_ranges = [AddrRange('512MB')]

# CPU 생성 (X86 타이밍 심플 CPU)
system.cpu = X86TimingSimpleCPU()

# 캐시 생성
system.cpu.icache = L1ICache(options)
system.cpu.dcache = L1DCache(options)

# 캐시를 CPU에 연결
system.cpu.icache.connectCPU(system.cpu)
system.cpu.dcache.connectCPU(system.cpu)

# L2 버스 생성
system.l2bus = L2XBar()

# L1 캐시를 L2 버스에 연결
system.cpu.icache.connectBus(system.l2bus)
system.cpu.dcache.connectBus(system.l2bus)

# L2 캐시 생성 및 연결
system.l2cache = L2Cache(options)
system.l2cache.connectCPUSideBus(system.l2bus)

# 메모리 버스 생성
system.membus = SystemXBar()
system.l2cache.connectMemSideBus(system.membus)

# X86 특정 요구사항: 인터럽트 컨트롤러 생성 및 연결
system.cpu.createInterruptController()
system.cpu.interrupts[0].pio = system.membus.mem_side_ports
system.cpu.interrupts[0].int_requestor = system.membus.cpu_side_ports
system.cpu.interrupts[0].int_responder = system.membus.mem_side_ports

# 시스템 포트를 메모리 버스에 연결
system.system_port = system.membus.cpu_side_ports

# 메모리 컨트롤러 생성 및 연결
system.mem_ctrl = MemCtrl()
system.mem_ctrl.dram = DDR3_1600_8x8()
system.mem_ctrl.dram.range = system.mem_ranges[0]
system.mem_ctrl.port = system.membus.mem_side_ports

binary = 'tests/test-progs/hello/bin/x86/linux/hello'

# for gem5 V21 and beyond
system.workload = SEWorkload.init_compatible(binary)

process = Process()
process.cmd = [binary]
system.cpu.workload = process
system.cpu.createThreads()

# 루트 객체 생성
root = Root(full_system = False, system = system)
m5.instantiate()

print("Beginning simulation!")
exit_event = m5.simulate()
print('Exiting @ tick {} because {}'
      .format(m5.curTick(), exit_event.getCause()))