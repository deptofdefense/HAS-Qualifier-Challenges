import csv
import struct
import sys

SAMPLE_RATE = 102400


def convert(file_path_base):

    in_f = file_path_base + ".bin"
    out_f = file_path_base + ".csv"

    write_samples_to_file(out_f, get_samples(in_f), SAMPLE_RATE)


def write_samples_to_file(output_file, samples, sample_rate):
    sample_period = 1.0 / float(sample_rate)
    with open(output_file, 'w+') as f:
        writer = csv.DictWriter(f, dialect='excel',
                                fieldnames=['timestamp', 'azimuth_amplitude', 'elevation_amplitude'])
        for i, (az_sample, el_sample) in enumerate(samples):
            writer.writerow(
                {"timestamp": f"{i*sample_period}",
                 "azimuth_amplitude": f"{az_sample:f}",
                 "elevation_amplitude": f"{el_sample:f}"
                 }
            )

        print(f"Wrote out {i*sample_period} seconds of data")


def get_samples(file_path):
    sample_fmt = "<ff"

    with open(file_path, 'rb') as f:
        while True:
            try:
                data = f.read(8)
                if len(data) < 8:
                    break
                yield struct.unpack_from(sample_fmt, data)

            except EOFError:
                break


if __name__ == "__main__":
    path = sys.argv[1]
    convert(path)
