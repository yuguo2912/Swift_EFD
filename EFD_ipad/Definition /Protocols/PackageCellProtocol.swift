//
//  PackageCellProtocol.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 25/02/2025.
//

protocol PackageCellProtocol: AnyObject {
    func didDeletePackage(_ package: PackageDTO)
    func didUpdatePackage(_ package: PackageDTO)
}
